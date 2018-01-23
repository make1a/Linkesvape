//
//  HNLanguageCell.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNLanguageCell.h"

@implementation HNLanguageCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self masLayoutSubview];
    }
    return self;
}

#pragma  mark - 布局
- (void)masLayoutSubview{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).mas_offset(Handle_width(14));
        make.width.mas_equalTo(Handle_width(72));
    }];
    
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-Handle_width(15));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(Handle_width(22));
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
    }
    return _titleLabel;

}

- (UIImageView *)checkImageView{
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc]init];
        _checkImageView.image = [UIImage imageNamed:@"connected"];
        [self.contentView addSubview:_checkImageView];
    }
    return _checkImageView;
}
@end



