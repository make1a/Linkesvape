//
//  HNFindPwdViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNFindPwdViewController.h"
#import "HNFindPwdContainerView.h"


@interface HNFindPwdViewController ()
@property (nonatomic,strong)HNFindPwdContainerView *containerView;
@end

@implementation HNFindPwdViewController
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
    [self setNavigationTitle:NSLocalizedString(@"找回密码", nil)];
}
#pragma mark - 网络请求
- (void)forgetPwd
{
    NSString *register_code = self.containerView.registerCodeView.textField.text;
    NSString *password = self.containerView.pwdView.textField.text;;
    NSString *confirm_password = self.containerView.actionPwdView.textField.text;
    
    if (register_code.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入注册码", nil)];
        return;
    }
    
    NSDictionary *dic = @{
                          @"register_code":register_code,
                          @"password" : password,
                          @"confirm_password" : confirm_password
                          };
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:ForgetPwd requestParameters:dic requestHeader:nil success:^(id responseObject) {
        
        if (CODE != 200)
        {
            [MBProgressHUD showError:NSLocalizedString(responseObject[@"m"], nil)];
            return ;
        }
        [MBProgressHUD showSuccess:NSLocalizedString(@"密码修改成功", nil)];
        [self.navigationController popViewControllerAnimated:YES];
        
    } faild:^(NSError *error) {
        [MBProgressHUD showError:NSLocalizedString(@"加载失败", nil)];
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
- (HNFindPwdContainerView *)containerView{
    if (!_containerView) {
        _containerView = [[HNFindPwdContainerView alloc]init];
        [self.view addSubview:_containerView];
        [_containerView.sumbitButton addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}


@end

