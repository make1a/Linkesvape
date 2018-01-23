//
//  HNTableHedView.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNTableHedView.h"

@implementation HNTableHedView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self masLayoutSubviews];
    }
    return self;
}

- (void)masLayoutSubviews{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
        make.bottom.mas_equalTo(self).mas_offset(-Handle_height(10));
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
        [_titleLabel setFont:[UIFont systemFontOfSize:Handle_width(14)]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titleLabel;
    
}
@end
