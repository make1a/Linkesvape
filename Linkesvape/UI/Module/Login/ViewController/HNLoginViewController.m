//
//  HNLoginViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/26.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNLoginViewController.h"
#import "HNRegisterViewController.h"
#import "HNLoginContainerView.h"
#import "HNFindPwdViewController.h"
#import "HNMainContainerView.h"
#import "AppDelegate.h"
#import "HNBaseLiveTabBarController.h"


@interface HNLoginViewController ()
@property (nonatomic,strong)HNLoginContainerView *containerView;

@end

@implementation HNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationStyle];
    [self masLayoutSubViews];
}

- (void)setNavgationStyle{
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark - 网络请求
- (void)loginApp
{
    NSString *userName = self.containerView.loginTextFieldView.textField.text ;
    NSString *password = self.containerView.pwdTextFieldView.textField.text ;;
    
    if (userName.textLength == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入用户名", nil)];
        return;
    }
    
//    if (password.textLength == 0) {
//        [MBProgressHUD showError:NSLocalizedString(@"请输入密码", nil)];
//        return;
//    }
    
    NSDictionary  *dict = @{
                            @"user_name" : userName,
                            @"password" : password,
                            @"uniqueid" : kUDID == nil ? @"" : kUDID
                            };
    
    [MBProgressHUD showMessage:NSLocalizedString(@"登录中", nil)];
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:Login requestParameters:dict requestHeader:nil success:^(id responseObject) {

        [MBProgressHUD hideHUD];
        
        if (CODE != 200)
        {
            [MBProgressHUD showError:NSLocalizedString(responseObject[@"m"], nil)];
            return ;
        }
        
        [MBProgressHUD showSuccess:NSLocalizedString(@"登录成功", nil)];
        
        HNUserModel *userModel = [HNUserModel shareInstance];
        userModel = [HNUserModel yy_modelWithJSON:responseObject[@"d"][@"account_info"]];

        NSString *token = responseObject[@"d"][@"token"];

        [UserDefault setValue:token forKey:@"token"];
        [UserDefault setValue:userModel.uid forKey:@"userId"];
        [UserDefault synchronize];

        AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HNBaseLiveTabBarController *vc = [[HNBaseLiveTabBarController alloc] init];
        delegate.window.rootViewController = vc;
        
    } faild:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        ERROR;
    }];
}

#pragma mark - 点击
- (void)registerAction:(UIButton *)sender{
    HNRegisterViewController *vc = [HNRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)findPwdAction:(id)sender{
    HNFindPwdViewController *vc = [HNFindPwdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 布局
-(void)masLayoutSubViews{
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



#pragma mark - 懒加载
- (HNLoginContainerView *)containerView{
    if (!_containerView) {
        _containerView = [HNLoginContainerView new];
        [self.view addSubview:_containerView];
        [_containerView.registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.forgetPwdButton addTarget:self action:@selector(findPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.loginButton addTarget:self action:@selector(loginApp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}
@end
