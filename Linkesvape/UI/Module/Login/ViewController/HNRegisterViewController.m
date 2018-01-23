//
//  HNRegisterViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNRegisterViewController.h"
#import "HNRegisterContainerView.h"
#import "AppDelegate.h"
#import "HNBaseLiveTabBarController.h"
#import "HNWebViewController.h"
@interface HNRegisterViewController ()
@property (nonatomic,strong)HNRegisterContainerView *containerView;
@end

@implementation HNRegisterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self masLayoutSubviews];
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"注册", nil)];
}
#pragma mark - 点击
- (void)registerAction:(id)sender{
    [self registerUser];
}
- (void)clickXyButton:(id)sender{
    //语言
    NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];
    HNWebViewController *vc = [HNWebViewController new];
    vc.urlString = [NSString stringWithFormat:@"http://118.126.111.250/h5/index/detail?Accept-Language=%@&type=privacy",language];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求
- (void)registerUser
{
    NSString *userName = self.containerView.userNameView.textField.text;
    NSString *registerCode = self.containerView.registerCodeView.textField.text;
    NSString *password = self.containerView.pwdView.textField.text;
    NSString *actionPwd = self.containerView.actionPwdView.textField.text;
    
    if (userName.isSpecialCharacters) {
        [MBProgressHUD showError:NSLocalizedString(@"用户名不能包含特殊字符", nil)];
        return;
    }
    
    if (userName.length <4 || userName.length>16) {
        [MBProgressHUD showError:NSLocalizedString(@"用户名长度不对", nil)];
        return;
    }
    
    if (registerCode.textLength == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入注册码", nil)];
        return;
    }
    
    if (![password isEqualToString:actionPwd]) {
        [MBProgressHUD showError:NSLocalizedString(@"两次输入密码不一致", nil)];
        return;
    }
    
    
    NSDictionary *dic = @{
                          @"user_name" : userName,
                          @"register_code" : registerCode,
                          @"password" : password,
                          @"uniqueid" : kUDID == nil ? @"" : kUDID
                          };
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:RegisterSeconed requestParameters:dic requestHeader:nil success:^(id responseObject) {
        
        if (CODE != 200)
        {
            [MBProgressHUD showError:responseObject[@"m"]];
            return ;
        }
        
        [MBProgressHUD showSuccess:@"恭喜您，注册成功"];
        
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
        ERROR;
    }];
}

#pragma mark - 布局
- (void)masLayoutSubviews{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}
#pragma  mark - 懒加载
- (HNRegisterContainerView *)containerView{
    if (!_containerView) {
        _containerView = [[HNRegisterContainerView alloc]init];
        [self .view addSubview:_containerView];
        [_containerView.sumbitButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView.xyButton addTarget:self action:@selector(clickXyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}


@end
