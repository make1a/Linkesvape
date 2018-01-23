//
//  HNRegisterTextfieldView.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNRegisterTextfieldView.h"

@implementation HNRegisterTextfieldView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self masLayoutSubViews];
    }
    return self;
}
#pragma mark - 布局
- (void)masLayoutSubViews{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(40));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height);
        make.left.mas_equalTo(self.textLabel.mas_left).mas_offset(Handle_width(90));
    }];
}
#pragma mark - 懒加载
- (UILabel *)textLabel
{
    if(!_textLabel)
    {
        UIView *superView = self;
        _textLabel = [[UILabel alloc]init];
        [superView addSubview:_textLabel];
        [_textLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_textLabel setTextColor:[UIColor blackColor]];
    }
    return _textLabel;
}
- (UITextField *)textField
{
    if(!_textField)
    {
        UIView *superView = self;
        _textField = [[UITextField alloc]init];
        [superView addSubview:_textField];
//        _textField.placeholder = NSLocalizedString(@"用户名将用于登陆账号", nil);
        
    }
    return _textField;
}

@end
