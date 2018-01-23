//
//  HNBaseBankView.m
//  LiveShow
//
//  Created by Sunwanwan on 2017/8/10.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNBaseBankView.h"

@implementation HNBaseBankView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUI];
        
        if (!CurrentThemeIsWhite)
        {
            self.descLab.textColor = [UIColor whiteColor];
        }
    }
    return self;
}

#pragma mark - privateMethod

- (void)refreshBtnClick:(UIButton *)btn
{
    if (self.refreshBtnClick)
    {
        self.refreshBtnClick();
    }
}

#pragma mark - setUI

- (void)setUI
{
    [self addSubview:self.iconImg];
    [self addSubview:self.descLab];
    [self addSubview:self.refreshBtn];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-Handle(20));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImg.mas_bottom).mas_offset(Handle(20));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLab.mas_bottom).mas_offset(Handle(40));
        make.centerX.mas_equalTo(self.centerX);
        make.width.mas_offset(Handle_width(256 / 2));
        make.height.mas_offset(Handle_height(33));
    }];
}

#pragma mark - getter

- (UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"defaultpage_null"];
    }
    return _iconImg;
}

- (UILabel *)descLab
{
    if(!_descLab)
    {
        _descLab = [[UILabel alloc] init];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.font = [UIFont systemFontOfSize:14];
        _descLab.textColor = CString(SubtitleColor);
    }
    return _descLab;
}

- (UIButton *)refreshBtn
{
    if(!_refreshBtn)
    {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refreshBtn.backgroundColor = BtnBgColor;
        _refreshBtn.layer.cornerRadius = Handle(33 / 2);
        _refreshBtn.layer.masksToBounds = YES;
        [_refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _refreshBtn.hidden = YES;
    }
    return _refreshBtn;
}

@end
