
//
//  HNConsoleMainHeadView.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleMainHeadView.h"



@interface HNConsoleMainHeadView()


@end
@implementation HNConsoleMainHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
        [self masLayoutSubviews];
    }
    return self;
}

- (void)clickRightButton{
    if (self.pressRightButtonBlock) {
        self.pressRightButtonBlock();
    }
}

- (void)masLayoutSubviews{
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-Handle_width(15));
    }];

    
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Handle_width(75));
        make.height.mas_equalTo(Handle_height(35));
    }];

    [self.pageUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.pageLabel.mas_left).mas_offset(-Handle_width(20));
    }];

    [self.pageDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pageLabel.mas_right).mas_offset(Handle_width(20));
        make.centerY.mas_equalTo(self);
    }];
}

#pragma  mark - 懒加载
- (UIButton *)rightButton
{
    if(!_rightButton)
    {
        UIView *superView = self;
        _rightButton = [[UIButton alloc]init];
        [superView addSubview:_rightButton];
        [_rightButton setImage:[UIImage imageNamed:@"playlist"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIButton *)leftButton
{
    if(!_leftButton)
    {
        UIView *superView = self;
        _leftButton = [[UIButton alloc]init];
        [superView addSubview:_leftButton];
        [_leftButton setImage:[UIImage imageNamed:@"order_of_play"] forState:UIControlStateNormal];
    }
    return _leftButton;
}
- (UIButton *)pageUpButton
{
    if(!_pageUpButton)
    {
        UIView *superView = self;
        _pageUpButton = [[UIButton alloc]init];
        [superView addSubview:_pageUpButton];
        [_pageUpButton setImage:[UIImage imageNamed:@"on_a"] forState:UIControlStateNormal];
    }
    return _pageUpButton;
}
- (UIButton *)pageDownButton
{
    if(!_pageDownButton)
    {
        UIView *superView = self;
        _pageDownButton = [[UIButton alloc]init];
        [superView addSubview:_pageDownButton];
        [_pageDownButton setImage:[UIImage imageNamed:@"following_piece"] forState:UIControlStateNormal];
    }
    return _pageDownButton;
}
- (UILabel *)pageLabel
{
    if(!_pageLabel)
    {
        UIView *superView = self;
        _pageLabel = [[UILabel alloc]init];
        [superView addSubview:_pageLabel];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [_pageLabel setFont:[UIFont systemFontOfSize:Handle_width(14)]];;
        [_pageLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _pageLabel.backgroundColor = [UIColor whiteColor];
        _pageLabel.layer.masksToBounds = YES;
        _pageLabel.layer.cornerRadius = 5.f;
        _pageLabel.text = @"1/100";
    }
    return _pageLabel;
}

@end

