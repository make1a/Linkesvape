
//
//  HNConsoleModelEditCell.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleModelEditCell.h"
@interface HNConsoleModelEditCell ()
@property (nonatomic,strong)NSMutableArray * buttonArray;
@end
@implementation HNConsoleModelEditCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayouySubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)cellRefreshWithIndexPath:(NSInteger )section andModel:(HNCustomInfoModel *)info andSelectIndex:(NSInteger)selectIndex selectSection:(NSInteger)selectSection{
   HNSingleLightModel *lightModel = info.lamps[section-2];
    for (int i = 0; i<lightModel.infos.count; i++) {
        HNLightInfoModel *info = lightModel.infos[i];
        UIButton *button = self.buttonArray[i];
        button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        if (info.color.length == 6) { //设置颜色
            [button setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:info.color];
        }else{
//            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"big_turn_off_the_lights"] forState:UIControlStateNormal];
        }
    }
    if (section == selectSection) { //边框颜色
        if (selectIndex == -1) {
            return;
        }
        UIButton *button = self.buttonArray[selectIndex];
        button.layer.borderColor = [UIColor colorWithHexString:@"1d98f2"].CGColor;
    }
}
- (void)setButtonStatusNor{
    for (UIButton *sender in self.buttonArray) {
        sender.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
}
#pragma  mark - actions
- (void)clickEditButton:(id)sender{
    if (self.pressEditBtnBlock) {
        self.pressEditBtnBlock();
    }
}

- (void)clickButton:(UIButton *)sender{
    for (UIButton *button in self.buttonArray) {
        button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    sender.layer.borderColor = [UIColor colorWithHexString:@"1d98f2"].CGColor;
    if (self.pressDeviceBtnBlock) {
        self.pressDeviceBtnBlock(sender.tag-100);
    }
}

- (void)setButtonColor:(NSString *)hexColor AndIndex:(NSInteger)tag{
   UIButton *button = self.buttonArray[tag];
    if (hexColor.length == 6) { //设置颜色
        [button setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:hexColor];
    }else{
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"big_turn_off_the_lights"] forState:UIControlStateNormal];
    }
}

- (void)masLayouySubviews{

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(Handle_height(15));
        make.left.mas_equalTo(self).mas_offset(Handle_width(15));
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(Handle_width(10));
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    
    CGFloat w = Handle_width(42);
    CGFloat h = Handle_height(20);
    CGFloat space = Handle_height(24);
    
    CGFloat labelH = Handle_height(13);
    CGFloat labelW = Handle_width(26);
    
    int number = 0;
    for (int y = 0; y<2; y++) {
        for (int i = 0; i<8; i++) {

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.layer.borderColor = [UIColor colorWithHexString:@"1d98f2"].CGColor;
            button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
            button.layer.borderWidth = 1.f;
            [button setBackgroundImage:[UIImage imageNamed:@"big_turn_off_the_lights"] forState:UIControlStateNormal];
            button.frame = CGRectMake(Handle_width(15)+i*w, Handle_height(60)+y*(space+h), w, h);
            button.tag = number + 100;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
            //label
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(0, 0, labelW, labelH);
            label.center = CGPointMake(CGRectGetMinX(button.frame), CGRectGetMinY(button.frame)-labelH/2-5);
            label.font = [UIFont systemFontOfSize:Handle_width(12)];
            label.textColor = [UIColor colorWithHexString:@"666666"];
            [self.contentView addSubview:label];
            label.text = [NSString stringWithFormat:@"%.1f",number*0.2];
            
            number++;
            
            if (i == 7) { //最后一个
                UILabel *lastLabel = [[UILabel alloc]init];
                lastLabel.frame = CGRectMake(0, 0, labelW, labelH);
                lastLabel.center = CGPointMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame)-labelH/2-5);
                lastLabel.font = [UIFont systemFontOfSize:Handle_width(12)];
                lastLabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.contentView addSubview:lastLabel];
                lastLabel.text = [NSString stringWithFormat:@"%.1f",number*0.2];
            }
        }
    }
}   

- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        UIView *superView = self;
        _nameLabel = [[UILabel alloc]init];
        [superView addSubview:_nameLabel];
        [_nameLabel setFont:[UIFont systemFontOfSize:Handle_width(16)]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _nameLabel.text = @"灯1";
    }
    return _nameLabel;
}
- (UIButton *)editButton
{
    if(!_editButton)
    {
        UIView *superView = self;
        _editButton = [[UIButton alloc]init];
        [superView addSubview:_editButton];
        [_editButton setImage:[UIImage imageNamed:@"light_editor"] forState:UIControlStateNormal];
    }
    return _editButton;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [@[] mutableCopy];
    }
    return _buttonArray;
}
@end
