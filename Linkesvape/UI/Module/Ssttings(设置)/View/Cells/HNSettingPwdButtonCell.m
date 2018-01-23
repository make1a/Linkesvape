//
//  HNSettingPwdButtonCell.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingPwdButtonCell.h"

@implementation HNSettingPwdButtonCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self masLayoutSubview];
    }
    return self;
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
        make.right.mas_equalTo(self).mas_offset(-Handle_width(15));
        make.top.bottom.mas_equalTo(self);
    }];
}

#pragma  mark - 懒加载
- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UIView *superView = self.contentView;
        _titleLabel = [[UILabel alloc]init];
        [superView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        _titleLabel.text = NSLocalizedString(@"确定", nil);
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"1d98f2"];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 5.f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


