//
//  HNSettingPwdCell.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingPwdCell.h"

@interface HNSettingPwdCell()

@end
@implementation HNSettingPwdCell
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

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).mas_offset(Handle_width(14));
        make.width.mas_equalTo(Handle_width(72));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).mas_offset(Handle_width(78/2));
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
    
    UIView *lineView = ({
        lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(1);
        }];
        lineView;
    });
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

- (UITextField *)textField{
    if(!_textField)
    {
        UIView *superView = self.contentView;
        _textField = [[UITextField alloc]init];
        [superView addSubview:_textField];
    }
    return _textField;
}
@end


