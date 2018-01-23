//
//  HNMainNewsCell.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainNewsCell.h"

@implementation HNMainNewsCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayoutSubview];
    }
    return self;
}
#pragma  mark - 刷新
- (void)cellRefreshWithModel:(HNNewsModel *)model{
    self.headTitleLabel.text = model.title;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.addtime integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (date.daysAgo<=30){
        if (date.hoursAgo<24) {
            self.timeLabel.text = [NSString stringWithFormat:@"%.0f%@",date.hoursAgo,NSLocalizedString(@"小时前", nil)];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%ld%@",(long)date.daysAgo,NSLocalizedString(@"天前", nil)];
        }
    }else{
        self.timeLabel.text = [formatter stringFromDate:date];
    }

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.title_img] placeholderImage:[UIImage imageNamed:@"information_loading"]];
}
#pragma  mark - 布局
- (void)masLayoutSubview{
    
    [self.headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(Handle_width(15));
        make.top.mas_equalTo(self.contentView).mas_offset(Handle_height(8));
        make.right.mas_equalTo(self.headImageView.mas_left).mas_offset(Handle_width(-15));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headTitleLabel);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-Handle_height(10));
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-Handle_width(15));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(Handle_height(59));
        make.width.mas_equalTo(Handle_width(105));
    }];
}

#pragma  mark - 懒加载
- (UILabel *)headTitleLabel
{
    if(!_headTitleLabel)
    {
        UIView *superView = self.contentView;
        _headTitleLabel = [[UILabel alloc]init];
        [superView addSubview:_headTitleLabel];
        [_headTitleLabel setFont:[UIFont systemFontOfSize:Handle_height(15)]];
        [_headTitleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _headTitleLabel.numberOfLines = 2;
        _headTitleLabel.text = @"小马云大马云喊老马云的巴巴爸爸爸爸爸爸爸爸爸爸";
    }
    return _headTitleLabel;
}
- (UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        UIView *superView = self.contentView;
        _timeLabel = [[UILabel alloc]init];
        [superView addSubview:_timeLabel];
        [_timeLabel setFont:[UIFont systemFontOfSize:Handle_height(12)]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"BDBDBD"]];
        _timeLabel.text = @"2012-12-12";
    }
    return _timeLabel;
}
- (UIImageView *)headImageView
{
    if(!_headImageView)
    {
        UIView *superView = self.contentView;
        _headImageView = [[UIImageView alloc]init];
        [superView addSubview:_headImageView];
        _headImageView.image = [UIImage imageNamed:@"information_loading"];
    }
    return _headImageView;
}


@end
