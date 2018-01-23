//
//  HNFindPwdContainerView.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNFindPwdContainerView.h"
@interface HNFindPwdContainerView()
@property (nonatomic,strong)UILabel *headTitleLabel;
@end

@implementation HNFindPwdContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.f];
        [self masLayoutSubviews];
    }
    return self;
}

- (void)masLayoutSubviews{
    [self.headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
        make.top.mas_equalTo(self).mas_offset(Handle_height(13));
    }];
    
    [self.registerCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headTitleLabel.mas_bottom).mas_offset(Handle_height(15));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(Handle_height(37));
    }];
    
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerCodeView.mas_bottom).mas_offset(Handle_height(1));
        make.height.mas_equalTo(self.registerCodeView);
        make.left.right.mas_equalTo(self);
    }];
    
    [self.actionPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdView.mas_bottom).mas_offset(Handle_height(1));
        make.height.mas_equalTo(self.registerCodeView);
        make.left.right.mas_equalTo(self);
    }];
    
    [self.sumbitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionPwdView.mas_bottom).mas_offset(Handle_height(25));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(Handle_height(40));
        make.width.mas_equalTo(Handle_width(345));
    }];
}


#pragma mark -懒加载

- (HNRegisterTextfieldView *)registerCodeView
{
    if(!_registerCodeView)
    {
        UIView *superView = self;
        _registerCodeView = [[HNRegisterTextfieldView alloc]init];
        [superView addSubview:_registerCodeView];
        _registerCodeView.textLabel.text = NSLocalizedString(@"注册码", nil);
        _registerCodeView.textField.placeholder = NSLocalizedString(@"请输入注册码", nil);
    }
    return _registerCodeView;
}
- (HNRegisterTextfieldView *)pwdView
{
    if(!_pwdView)
    {
        UIView *superView = self;
        _pwdView = [[HNRegisterTextfieldView alloc]init];
        [superView addSubview:_pwdView];
        _pwdView.textLabel.text = NSLocalizedString(@"密码", nil);
        _pwdView.textField.placeholder = NSLocalizedString(@"请输入密码(选填)", nil);
    }
    return _pwdView;
}
- (HNRegisterTextfieldView *)actionPwdView
{
    if(!_actionPwdView)
    {
        UIView *superView = self;
        _actionPwdView = [[HNRegisterTextfieldView alloc]init];
        [superView addSubview:_actionPwdView];
        _actionPwdView.textLabel.text = NSLocalizedString(@"确认密码", nil);
        _actionPwdView.textField.placeholder = NSLocalizedString(@"请再次输入密码(选填)", nil);
    }
    return _actionPwdView;
}
- (UIButton *)sumbitButton
{
    if(!_sumbitButton)
    {
        UIView *superView = self;
        _sumbitButton = [[UIButton alloc]init];
        [superView addSubview:_sumbitButton];
        [_sumbitButton setTitle:NSLocalizedString(@"找回密码", nil) forState:UIControlStateNormal];
        [_sumbitButton setBackgroundColor:[UIColor colorWithHexString:@"1E98F2"]];
        _sumbitButton.layer.masksToBounds = YES;
        _sumbitButton.layer.cornerRadius = 8.f;
    }
    return _sumbitButton;
}

- (UILabel *)headTitleLabel
{
    if(!_headTitleLabel)
    {
        UIView *superView = self;
        _headTitleLabel = [[UILabel alloc]init];
        [superView addSubview:_headTitleLabel];
        _headTitleLabel.text = NSLocalizedString(@"设置新密码需要输入账号注册码", nil);
        [_headTitleLabel setFont:[UIFont systemFontOfSize:Handle_width(12)]];
        [_headTitleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _headTitleLabel;
}



@end

