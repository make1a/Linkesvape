//
//  HNPayListHeadView.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNPayListHeadView.h"

@implementation HNPayListHeadView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self masLayoutSubviews];
    }
    return self;
}

- (void)clickRightButton:(UIButton *)sender{
    sender.selected  = !sender.selected;
    
    if (self.pressEditButton) {
        self.pressEditButton();
    }
}

- (void)clickLeftButton:(id)sender{
    if (self.order == HNPlayrandom) {
        
        [self setPlayListOrder:HNPlaycirculate];
        
    }else if (self.order == HNPlaycirculate){
        
        [self setPlayListOrder:HNPlayInOrder];
    }else{
        [self setPlayListOrder:HNPlayrandom];
    }
}

- (void)masLayoutSubviews{
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(14);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(Handle_width(15));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playLabel.mas_right);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(14));
        make.centerY.mas_equalTo(self);
    }];
}

#pragma  mark - 懒加载
- (UIButton *)leftButton
{
    if(!_leftButton)
    {
        UIView *superView = self;
        _leftButton = [[UIButton alloc]init];
        [superView addSubview:_leftButton];
        [_leftButton setImage:[UIImage imageNamed:@"order_of_play"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UILabel *)playLabel
{
    if(!_playLabel)
    {
        UIView *superView = self;
        _playLabel = [[UILabel alloc]init];
        _playLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _playLabel.font = [UIFont systemFontOfSize:Handle_width(15)];
        _playLabel.text = @"aaaa";
        [superView addSubview:_playLabel];
    }
    return _playLabel;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UIView *superView = self;
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.font = [UIFont systemFontOfSize:Handle_width(15)];
        [superView addSubview:_titleLabel];
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
        [_rightButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
        [_rightButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateSelected];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
} 

- (void)setPlayListOrder:(HNPlayModelOrder)order{
    _order = order;
    if (order == HNPlayInOrder) { //顺序
        
        [self.leftButton setImage:[UIImage imageNamed:@"order_of_play"] forState:UIControlStateNormal];
        self.playLabel.text = NSLocalizedString(@"顺序播放", nil);
        
    }else if(order == HNPlayrandom){ //随机
        
        [self.leftButton setImage:[UIImage imageNamed:@"random_play"] forState:UIControlStateNormal];
        self.playLabel.text = NSLocalizedString(@"随机播放", nil);
        
    }else{ //循环
        
        [self.leftButton setImage:[UIImage imageNamed:@"a_single_cycle"] forState:UIControlStateNormal];
        self.playLabel.text = NSLocalizedString(@"单曲循环", nil);
        
    }
}
@end
