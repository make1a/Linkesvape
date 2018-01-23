//
//  HNNoticeInputView.m
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNNoticeInputView.h"
@interface HNNoticeInputView ()
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UIView * containerView;
@end
@implementation HNNoticeInputView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.2 alpha:.5];
        [self masLayoutSubviews];
    }
    return self;
}
#pragma  mark - 点击
- (void)dismiss{
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point=[[touches anyObject]locationInView:self];
    CALayer *layer=[self.layer hitTest:point];
    if (layer == self.layer) {
        [self dismiss];
    }
}
- (void)clickSumbitButton:(id)sender{
    if (self.pressSumbitButtonBlock) {
        self.pressSumbitButtonBlock();
    }
    [self dismiss];
}
#pragma  mark - 布局
- (void)masLayoutSubviews{
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(32));
        make.top.mas_equalTo(self).mas_offset(Handle_height(90));
        make.width.mas_equalTo(Handle_width(310));
        make.height.mas_equalTo(Handle_height(142));
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).mas_offset(Handle_height(30));
        make.left.mas_equalTo(self.containerView).mas_offset(Handle_width(20));
    }];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(Handle_height(30));
        make.width.mas_equalTo(Handle_width(540/2));
        make.centerY.mas_equalTo(self.containerView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textfield.mas_bottom);
        make.left.mas_equalTo(self.textfield);
        make.width.mas_equalTo(self.textfield);
        make.height.mas_equalTo(1);
    }];
    
    [self.sumbitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-Handle_width(20));
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(Handle_height(20));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.sumbitButton.mas_left).mas_offset(-Handle_width(50));
        make.centerY.mas_equalTo(self.sumbitButton);
    }];
}

#pragma  mark - 懒加载
- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UIView *superView = self.containerView;
        _titleLabel = [[UILabel alloc]init];
        [superView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:Handle_width(32/2)]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _titleLabel.text = @"修改设备名称";
    }
    return _titleLabel;
}
- (UITextField *)textfield
{
    if(!_textfield)
    {
        UIView *superView = self.containerView;
        _textfield = [[UITextField alloc]init];
        _textfield.borderStyle = UITextBorderStyleNone;
        [superView addSubview:_textfield];
    }
    return _textfield;
}
- (UIButton *)sumbitButton
{
    if(!_sumbitButton)
    {
     UIView *superView = self.containerView;
        _sumbitButton = [[UIButton alloc]init];
        [superView addSubview:_sumbitButton];
        [_sumbitButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_sumbitButton setTitleColor:[UIColor colorWithHexString:@"1D98F2"] forState:UIControlStateNormal];
        _sumbitButton.titleLabel.font = [UIFont systemFontOfSize:Handle_width(16)];
        [_sumbitButton addTarget:self action:@selector(clickSumbitButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sumbitButton;
}
- (UIButton *)cancelButton
{
    if(!_cancelButton)
    {
        UIView *superView = self.containerView;
        _cancelButton = [[UIButton alloc]init];
        [superView addSubview:_cancelButton];
        [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:Handle_width(16)];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIView *)lineView
{
    if(!_lineView)
    {
        UIView *superView = self.containerView;
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [superView addSubview:_lineView];
    }
    return _lineView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius =5.f;
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
    }
    return _containerView;
}
@end
