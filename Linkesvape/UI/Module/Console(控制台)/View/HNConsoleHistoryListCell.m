//
//  HNConsoleHistoryListCell.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleHistoryListCell.h"

@implementation HNConsoleHistoryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayouySubviews];
    }
    return self;
}

- (void)clickRightButton{
    if (self.pressRightBtnBlock) {
        self.pressRightBtnBlock();
    }
    
}

- (void)masLayouySubviews{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(15));
        make.centerY.mas_equalTo(self);
    }];
}

#pragma  mark - 懒加载
- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UIView *superView = self;
        _titleLabel = [[UILabel alloc]init];
        [superView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _titleLabel.text = @"系统模式名称";
    }
    return _titleLabel;
}
- (UIButton *)rightButton
{
    if(!_rightButton)
    {
        UIView *superView = self;
        _rightButton = [[UIButton alloc]init];
        [superView addSubview:_rightButton];
        [_rightButton setImage:[UIImage imageNamed:@"join_in"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
