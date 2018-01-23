//
//  HNNoticePlayListView.m
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNNoticePlayListView.h"
@interface HNNoticePlayListView ()

@property (nonatomic,strong)UIView * containerView;
@end
@implementation HNNoticePlayListView
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
#pragma  mark - 布局
- (void)masLayoutSubviews{
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(32));
        make.top.mas_equalTo(self).mas_offset(Handle_height(158));
        make.width.mas_equalTo(Handle_width(310));
        make.height.mas_equalTo(Handle_height(220));
    }];
    
    [self.headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.containerView).mas_offset(Handle_height(25));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headTitleLabel.mas_bottom).mas_offset(Handle_height(15));
//        make.left.mas_equalTo(self.containerView).mas_offset(Handle_width(43));
        make.centerX.mas_equalTo(self.containerView);
    }];
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(Handle_height(18));
        make.width.mas_equalTo(Handle_width(450/2));
        make.height.mas_equalTo(Handle_height(30));
    }];
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(self.topButton);
        make.top.mas_equalTo(self.topButton.mas_bottom).mas_offset(Handle_height(10));
    }];
    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(self.topButton);
        make.top.mas_equalTo(self.centerButton.mas_bottom).mas_offset(Handle_height(10));
    }];
    
}
#pragma  mark - 懒加载
- (UILabel *)headTitleLabel
{
    if(!_headTitleLabel)
    {
        UIView *superView = self;
        _headTitleLabel = [[UILabel alloc]init];
        [superView addSubview:_headTitleLabel];
        [_headTitleLabel setFont:[UIFont boldSystemFontOfSize:Handle_width(16)]];
        [_headTitleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _headTitleLabel.text = NSLocalizedString(@"提示", nil);
    }
    return _headTitleLabel;
}
- (UILabel *)detailLabel
{
    if(!_detailLabel)
    {
        UIView *superView = self;
        _detailLabel = [[UILabel alloc]init];
        [superView addSubview:_detailLabel];
        [_detailLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_detailLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _detailLabel.text = NSLocalizedString(@"当前播放列表与设备播放列表不一致", nil);
    }
    return _detailLabel;
}
- (UIButton *)topButton
{
    if(!_topButton)
    {
        UIView *superView = self;
        _topButton = [[UIButton alloc]init];
        [superView addSubview:_topButton];
        [_topButton setTitle:NSLocalizedString(@"同步APP播放列表", nil) forState:UIControlStateNormal];
        [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topButton setBackgroundColor:[UIColor colorWithHexString:@"1d98f2"]];
        _topButton.layer.masksToBounds = YES;
        _topButton.layer.cornerRadius = Handle_width(5);
    }
    return _topButton;
}
- (UIButton *)centerButton
{
    if(!_centerButton)
    {
        UIView *superView = self;
        _centerButton = [[UIButton alloc]init];
        [superView addSubview:_centerButton];
        [_centerButton setTitle:NSLocalizedString(@"同步设备播放列表", nil) forState:UIControlStateNormal];
        [_centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_centerButton setBackgroundColor:[UIColor colorWithHexString:@"2BBE20"]];
        _centerButton.layer.masksToBounds = YES;
        _centerButton.layer.cornerRadius = Handle_width(5);
    }
    return _centerButton;
}
- (UIButton *)bottomButton
{
    if(!_bottomButton)
    {
        UIView *superView = self;
        _bottomButton = [[UIButton alloc]init];
        [superView addSubview:_bottomButton];
        [_bottomButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor colorWithHexString:@"1D98F2"] forState:UIControlStateNormal];
        [_bottomButton setBackgroundColor:[UIColor whiteColor]];
        _bottomButton.layer.borderColor = [UIColor colorWithHexString:@"1D98F2"].CGColor;
        _bottomButton.layer.borderWidth = Handle_height(1);
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.cornerRadius = Handle_width(5);
        [_bottomButton  addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
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
