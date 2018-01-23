//
//  HNConsoleListCell.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleListCell.h"

@implementation HNConsoleListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayouySubviews];
    }
    return self;
}


- (void)masLayouySubviews{
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(25));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(Handle_width(104/2));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(15));
        make.centerY.mas_equalTo(self);
    }];
}


- (void)clickRightButton{
    if (self.pressAddButtonBlock) {
        self.pressAddButtonBlock();
    }
    
}
#pragma  mark - 懒加载
- (UILabel *)numberLabel
{
    if(!_numberLabel)
    {
        UIView *superView = self;
        _numberLabel = [[UILabel alloc]init];
        [superView addSubview:_numberLabel];
        [_numberLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_numberLabel setTextColor:[UIColor colorWithHexString:@"666666"]];;
        _numberLabel.text = @"1";
    }
    return _numberLabel;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        UIView *superView = self;
        _nameLabel = [[UILabel alloc]init];
        [superView addSubview:_nameLabel];
        [_nameLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];;
        _nameLabel.text=@"系统模式";
    }
    return _nameLabel;
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
