//
//  HNConnectDeviceSucCell.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNConnectDeviceSucCell.h"
#import "HNDeviceConnectedModel.h"

@implementation HNConnectDeviceSucCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayoutSubview];
    }
    return self;
}

- (void)cellRefreshWithAlertName:(HNBleDeviceModel *)model{
    
    HNScanDeviceModel *scanModel = [HNScanDeviceModel selectFromClassPredicateWithFormat:[NSString stringWithFormat:@"where macAddress = '%@'",model.macAddress]].firstObject;
    if (scanModel) {
        model.name = scanModel.name;
    }
    self.headTitleLabel.text = model.name;
}

#pragma  mark - 点击
- (void)clickButton{
    if (self.pressEditorButton) {
        self.pressEditorButton();
    }
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
    
    [self.editorButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _headImageView.image = [UIImage imageNamed:@"connected"];
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
        [_headTitleLabel setFont:[UIFont systemFontOfSize:Handle_width(14)]];
        [_headTitleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _headTitleLabel.text = @"MAKEMAKE";
    }
    return _headTitleLabel;
}
- (UIButton *)editorButton
{
    if(!_editorButton)
    {
        UIView *superView = self.contentView;
        _editorButton = [[UIButton alloc]init];
        [superView addSubview:_editorButton];
        [_editorButton setImage:[UIImage imageNamed:@"editable"] forState:UIControlStateNormal];
        [_editorButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorButton;
}

@end
