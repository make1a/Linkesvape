//
//  HNMainDeviceCell.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainDeviceCell.h"


@interface HNMainDeviceCell ()
@property (nonatomic,assign)HNMainDeviceCellConnectStyle style;
@property (nonatomic,strong)UIImageView * rightArrowImageView;
@end
@implementation HNMainDeviceCell

#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayoutSubview];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)clickButton:(id)sender{
    if (self.pressConnectBlock) {
        self.pressConnectBlock();
    }
}

- (void)setCurrentStatusWithStyle:(HNMainDeviceCellConnectStyle)style{
    if (style == HNMainDeviceCellConnectOffLine) {
        self.headImageView.image = [UIImage imageNamed:@"unbound_equipment"];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"BDBDBD"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"BDBDBD"];
        self.powerLabel.text = @"";
        self.persentLabel.text = @"";
        self.connectButton.hidden = NO;
        self.rightArrowImageView.hidden = YES;
        self.statusLabel.text = NSLocalizedString(@"设备未连接", nil);
    }else{
        self.headImageView.image = [UIImage imageNamed:@"binding_equipment"];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.connectButton.hidden = YES;
        self.rightArrowImageView.hidden = NO;
        self.statusLabel.text = NSLocalizedString(@"设备已连接", nil);
    }
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    
    UIView *superView = self.contentView;
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superView).mas_offset(Handle_width(15));
        make.height.width.mas_equalTo(Handle_height(45));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(Handle_width(10));
        make.top.mas_equalTo(self.headImageView);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(Handle_height(10));
    }];
    
    [self.powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusLabel);
        make.left.mas_equalTo(self.statusLabel.mas_right).mas_offset(Handle_width(12));
    }];
    
    [self.persentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.powerLabel.mas_right);
        make.centerY.mas_equalTo(self.statusLabel);
    }];
    
    [self.connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superView);
        make.right.mas_equalTo(superView).mas_offset(-Handle_width(16));
        make.height.mas_equalTo(Handle_height(25));
        make.width.mas_equalTo(Handle_width(50));
    }];
    
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(superView).mas_offset(-Handle_width(15));
        make.centerY.mas_equalTo(superView);
    }];
}

#pragma  mark - 懒加载
- (UIImageView *)headImageView
{
    if(!_headImageView)
    {
        UIView *superView = self.contentView;
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image = [UIImage imageNamed:@"unbound_equipment"];
        [superView addSubview:_headImageView];
    }
    return _headImageView;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        UIView *superView = self.contentView;
        _nameLabel = [[UILabel alloc]init];
        [superView addSubview:_nameLabel];
        [_nameLabel setFont:[UIFont systemFontOfSize:Handle_height(15)]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _nameLabel.text = @"设备名称：MAKEMAKE";
    }
    return _nameLabel;
}
- (UILabel *)statusLabel
{
    if(!_statusLabel)
    {
        UIView *superView = self.contentView;
        _statusLabel = [[UILabel alloc]init];
        [superView addSubview:_statusLabel];
        [_statusLabel setFont:[UIFont systemFontOfSize:Handle_height(12)]];
        [_statusLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _statusLabel.text = NSLocalizedString(@"设备已连接", nil);
    }
    return _statusLabel;
}
- (UILabel *)powerLabel
{
    if(!_powerLabel)
    {
        UIView *superView = self.contentView;
        _powerLabel = [[UILabel alloc]init];
        [superView addSubview:_powerLabel];
        [_powerLabel setFont:[UIFont systemFontOfSize:Handle_height(12)]];
        [_powerLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _powerLabel.text = NSLocalizedString(@"剩余电量:", nil);
    }
    return _powerLabel;
}
- (UILabel *)persentLabel
{
    if(!_persentLabel)
    {
        UIView *superView = self.contentView;
        _persentLabel = [[UILabel alloc]init];
        [superView addSubview:_persentLabel];
        [_persentLabel setFont:[UIFont systemFontOfSize:Handle_height(12)]];
        [_persentLabel setTextColor:[UIColor colorWithHexString:@"2bbe20"]];
    }
    return _persentLabel;
}
- (UIButton *)connectButton
{
    if(!_connectButton)
    {
        UIView *superView = self.contentView;
        _connectButton = [[UIButton alloc]init];
        [superView addSubview:_connectButton];
        [_connectButton setTitle:NSLocalizedString(@"连接", nil) forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor colorWithHexString:@"1E98F2"] forState:UIControlStateNormal];
        [_connectButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        [_connectButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        _connectButton.layer.masksToBounds = YES;
//        _connectButton.layer.cornerRadius = 5.f;
//        _connectButton.layer.borderColor = [UIColor colorWithHexString:@"1E98F2"].CGColor;
        
    }
    return _connectButton;
}

- (UIImageView *)rightArrowImageView
{
    if(!_rightArrowImageView)
    {
        UIView *superView = self.contentView;
        _rightArrowImageView = [[UIImageView alloc]init];
        [superView addSubview:_rightArrowImageView];
        _rightArrowImageView.image = [UIImage imageNamed:@"next_step"];
    }
    return _rightArrowImageView;
}

@end
