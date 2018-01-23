//
//  HNSettingsCell.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingsCell.h"

@implementation HNSettingsCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
        [self masLayoutSubview];
    }
    return self;
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.mas_equalTo(self);
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
        [_titleLabel setFont:[UIFont systemFontOfSize:Handle_width(16)]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _titleLabel.text = NSLocalizedString(@"退出", nil);
    }
    return _titleLabel;
}

@end

