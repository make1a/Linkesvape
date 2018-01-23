//
//  HNLoginContainerView.m
//  Linkesvape
//
//  Created by make on 2017/12/26.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNLoginContainerView.h"

@interface HNLoginContainerView()
@property (nonatomic,strong)UIImageView *bgImageView;
@end

@implementation HNLoginContainerView

    
- (instancetype)init{
    self = [super init];
    if (self) {
        [self masLayoutSubViews];
    }
    return self;
}
    

- (void)masLayoutSubViews{
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(Handle_height(100));
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(Handle_width(90));
    }];
    
    [self.loginTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).mas_offset(Handle_height(65));
        make.height.mas_equalTo(Handle_height(40));
        make.width.mas_equalTo(Handle_width(275));
    }];
    
    [self.pwdTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.loginTextFieldView.mas_bottom).mas_offset(Handle_height(20));
        make.width.height.mas_equalTo(self.loginTextFieldView);
    }];
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdTextFieldView.mas_bottom).mas_offset(Handle_height(15));
        make.left.mas_equalTo(self.pwdTextFieldView);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.forgetPwdButton);
        make.right.mas_equalTo(self.pwdTextFieldView);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.registerButton.mas_bottom).mas_offset(Handle_height(60));
        make.height.mas_equalTo(Handle_height(44));
        make.width.mas_equalTo(Handle_width(130));
    }];
}
    
#pragma mark - 懒加载
- (HNLoginTextFieldView *)loginTextFieldView
{
    if(!_loginTextFieldView)
    {
        UIView *superView = self;
        _loginTextFieldView = [[HNLoginTextFieldView alloc]init];
        [superView addSubview:_loginTextFieldView];
        _loginTextFieldView.textField.placeholder = NSLocalizedString(@"账号", nil);
        _loginTextFieldView.imageView.image = [UIImage imageNamed:@"name"];
        
    }
    return _loginTextFieldView;
}

- (HNLoginTextFieldView *)pwdTextFieldView
{
    if(!_pwdTextFieldView)
    {
        UIView *superView = self;
        _pwdTextFieldView = [[HNLoginTextFieldView alloc]init];
        [superView addSubview:_pwdTextFieldView];
        _pwdTextFieldView.textField.placeholder = NSLocalizedString(@"密码", nil);
        _pwdTextFieldView.imageView.image = [UIImage imageNamed:@"cipher"];
        
    }
    return _pwdTextFieldView;
}

- (UIButton *)forgetPwdButton
{
    if(!_forgetPwdButton)
    {
        UIView *superView = self;
        _forgetPwdButton = [[UIButton alloc]init];
        [superView addSubview:_forgetPwdButton];
        [_forgetPwdButton setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [_forgetPwdButton setTitleColor:[UIColor colorWithHexString:@"1E98F2"] forState:UIControlStateNormal];
        _forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:Handle_width(14)];
        
    }
    return _forgetPwdButton;
}
- (UIButton *)registerButton
{
    if(!_registerButton)
    {
        UIView *superView = self;
        _registerButton = [[UIButton alloc]init];
        [superView addSubview:_registerButton];
        [_registerButton setTitle:NSLocalizedString(@"快速注册", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor colorWithHexString:@"1E98F2"] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:Handle_width(14)];
        
    }
    return _registerButton;
}
- (UIButton *)loginButton
{
    if(!_loginButton)
    {
        UIView *superView = self;
        _loginButton = [[UIButton alloc]init];
        [superView addSubview:_loginButton];
        [_loginButton setTitle:NSLocalizedString(@"登陆", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:Handle_width(15)];
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"1E98F2"]];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 8.f;
    }
    return _loginButton;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"ios_template_512"];
        [self addSubview:_logoImageView];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 16.f;
    }
    return _logoImageView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"landing_bg"];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
@end
