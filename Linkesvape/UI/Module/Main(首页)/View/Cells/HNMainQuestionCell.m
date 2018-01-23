//
//  HNMainQuestionCell.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainQuestionCell.h"

@implementation HNMainQuestionCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayoutSubview];
    }
    return self;
}
#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(Handle_width(14));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(Handle_width(10));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-Handle_width(15));
        make.centerY.mas_equalTo(self);
    }];
}

#pragma  mark - 懒加载
- (UIImageView *)headImageView
{
    if(!_headImageView)
    {
        UIView *superView = self.contentView;
        _headImageView = [[UIImageView alloc]init];
        [superView addSubview:_headImageView];
        _headImageView.image = [UIImage imageNamed:@"faq"];
    }
    return _headImageView;
}
- (UILabel *)headTitleLabel
{
    if(!_headTitleLabel)
    {
        UIView *superView = self.contentView;
        _headTitleLabel = [[UILabel alloc]init];
        [superView addSubview:_headTitleLabel];
        [_headTitleLabel setFont:[UIFont systemFontOfSize:Handle_height(15)]];
        [_headTitleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _headTitleLabel.text = NSLocalizedString(@"常见问题", nil);
    }
    return _headTitleLabel;
}
- (UIImageView *)arrowImageView
{
    if(!_arrowImageView)
    {
        UIView *superView = self.contentView;
        _arrowImageView = [[UIImageView alloc]init];
        [superView addSubview:_arrowImageView];
        _arrowImageView.image = [UIImage imageNamed:@"next_step"];
    }
    return _arrowImageView;
}


@end
