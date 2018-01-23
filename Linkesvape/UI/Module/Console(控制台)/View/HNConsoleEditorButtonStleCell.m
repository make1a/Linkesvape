//
//  HNConsoleEditorButtonStleCell.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleEditorButtonStleCell.h"
@interface HNConsoleEditorButtonStleCell()
@property (nonatomic,strong)NSMutableArray * colorButtonArray; //颜色按钮数组
@property (nonatomic,strong)NSArray * hzButtonArray; //HZ按钮数组
@property (nonatomic,strong)NSArray * colorArray; //颜色数组
@end
@implementation HNConsoleEditorButtonStleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self masLayouySubviews];
    }
    return self;
}

#pragma  mark - 点击
- (void)clickColorButton:(UIButton *)sender{
    for (UIButton *button in self.colorButtonArray) {
        
        button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    sender.layer.borderColor =[UIColor colorWithHexString:@"1d98f2"].CGColor;
    
    if (self.pressSelectColorBtnBlock) {
        self.pressSelectColorBtnBlock(sender.tag-100);
    }
}

//hz
- (void)clickHZButtonAction:(UIButton *)sender{
    for (UIButton *button in self.hzButtonArray) {
        button.selected = NO;
    }
    sender.selected = YES;
    
    if (self.pressSelectHZBtnBlock) {
        self.pressSelectHZBtnBlock(sender.tag-1000);
    }
}

//保存
- (void)saveInfoAction{
    if (self.pressSaveBtnBlock) {
        self.pressSaveBtnBlock();
    }
}


//退出
- (void)cancelAction{
    if (self.pressCancleBtnBlock) {
        self.pressCancleBtnBlock();
    }
}

#pragma  mark - 布局
- (void)masLayouySubviews{
    [self.colorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(30));
        make.top.mas_equalTo(self).mas_offset(Handle_height(20));
    }];

    [self.hzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorNameLabel.mas_bottom).mas_offset(Handle_height(25));
        make.left.mas_equalTo(self.colorNameLabel);
    }];
    
    [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hzLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self).mas_offset(Handle_height(55));
        make.height.mas_equalTo(Handle_height(30));
        make.width.mas_equalTo(Handle_width(154/2));
    }];
    
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lightButton.mas_right).mas_offset(Handle_width(20));
        make.top.width.height.mas_equalTo(self.lightButton);
    }];
    
    [self.slowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(30));
        make.top.width.height.mas_equalTo(self.lightButton);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(30));
        make.top.mas_equalTo(self.flashButton.mas_bottom).mas_offset(Handle_height(32/2));
        make.height.mas_equalTo(Handle_height(34));
        make.width.mas_equalTo(Handle_width(70));
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(self.saveButton);
        make.right.mas_equalTo(self.saveButton.mas_left).mas_offset(-Handle_width(15));
    }];
    
    
    CGFloat w = Handle_width(25);
    CGFloat space = Handle_width(10);
    
    for (int i = 0; i<8; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.colorArray.count-1>i) {
            button.backgroundColor = [UIColor colorWithHexString:self.colorArray[i]];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"small_to_turn_off_the_lights"] forState:UIControlStateNormal];
        }
        
        button.frame = CGRectMake(Handle_width(70)+i*(w+space), Handle_height(15), w, w);
        [self addSubview:button];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5.f;
        button.layer.borderWidth = Handle_width(1);
        button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        button.tag = 100+i;
        [self.colorButtonArray addObject:button];
        [button addTarget:self action:@selector(clickColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.hzButtonArray = @[self.lightButton,self.flashButton,self.slowButton];

}


- (UILabel *)colorNameLabel
{
    if(!_colorNameLabel)
    {
        UIView *superView = self;
        _colorNameLabel = [[UILabel alloc]init];
        [superView addSubview:_colorNameLabel];
        [_colorNameLabel setFont:[UIFont systemFontOfSize:Handle_width(14)]];
        [_colorNameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _colorNameLabel.text = NSLocalizedString(@"颜色", nil);
    }
    return _colorNameLabel;
}
- (UILabel *)hzLabel
{
    if(!_hzLabel)
    {
        UIView *superView = self;
        _hzLabel = [[UILabel alloc]init];
        [superView addSubview:_hzLabel];
        [_hzLabel setFont:[UIFont systemFontOfSize:Handle_width(14)]];
        [_hzLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _hzLabel.text = NSLocalizedString(@"频率:", nil);
    }
    return _hzLabel;
}
- (UIButton *)lightButton
{
    if(!_lightButton)
    {
        UIView *superView = self;
        _lightButton = [[UIButton alloc]init];
        [superView addSubview:_lightButton];
        [_lightButton setTitle:NSLocalizedString(@"常量", nil) forState:UIControlStateNormal];
        [_lightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_lightButton setBackgroundImage:[UIImage imageNamed:@"frame_bg"] forState:UIControlStateSelected];
        [_lightButton setBackgroundImage:[UIImage imageNamed:@"frame_bg2"] forState:UIControlStateNormal];
        [_lightButton setBackgroundColor:[UIColor whiteColor]];
        _lightButton.titleLabel.font = [UIFont  systemFontOfSize:Handle_width(16)];
        _lightButton.tag = 1001;
        [_lightButton addTarget:self action:@selector(clickHZButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}
- (UIButton *)flashButton
{
    if(!_flashButton)
    {
        UIView *superView = self;
        _flashButton = [[UIButton alloc]init];
        [superView addSubview:_flashButton];
        [_flashButton setTitle:NSLocalizedString(@"快闪", nil) forState:UIControlStateNormal];
        [_flashButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"frame_bg"] forState:UIControlStateSelected];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"frame_bg2"] forState:UIControlStateNormal];
        [_flashButton setBackgroundColor:[UIColor whiteColor]];
        _flashButton.titleLabel.font = [UIFont  systemFontOfSize:Handle_width(16)];
        _flashButton.tag = 1002;
        [_flashButton addTarget:self action:@selector(clickHZButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}
- (UIButton *)slowButton
{
    if(!_slowButton)
    {
        UIView *superView = self;
        _slowButton = [[UIButton alloc]init];
        [superView addSubview:_slowButton];
        [_slowButton setTitle:NSLocalizedString(@"慢闪", nil) forState:UIControlStateNormal];
        [_slowButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_slowButton setBackgroundImage:[UIImage imageNamed:@"frame_bg"] forState:UIControlStateSelected];
        [_slowButton setBackgroundImage:[UIImage imageNamed:@"frame_bg2"] forState:UIControlStateNormal];
        [_slowButton setBackgroundColor:[UIColor whiteColor]];
        _slowButton.titleLabel.font = [UIFont  systemFontOfSize:Handle_width(16)];
        _slowButton.tag = 1003;
        [_slowButton addTarget:self action:@selector(clickHZButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slowButton;
}
- (UIButton *)saveButton
{
    if(!_saveButton)
    {
        UIView *superView = self;
        _saveButton = [[UIButton alloc]init];
        [superView addSubview:_saveButton];
        [_saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"1d98f2"]];
        _saveButton.layer.cornerRadius = 5.f;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton addTarget:self action:@selector(saveInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (UIButton *)cancleButton
{
    if(!_cancleButton)
    {
        UIView *superView = self;
        _cancleButton = [[UIButton alloc]init];
        [superView addSubview:_cancleButton];
        [_cancleButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithHexString:@"1D98F2"] forState:UIControlStateNormal];
        [_cancleButton setBackgroundColor:[UIColor clearColor]];
        _cancleButton.layer.masksToBounds = YES;
        _cancleButton.layer.cornerRadius = 5.f;
        _cancleButton.layer.borderWidth = 1.f;
        _cancleButton.layer.borderColor = [UIColor colorWithHexString:@"1d98f2"].CGColor;
        [_cancleButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _cancleButton;
}
- (NSMutableArray *)colorButtonArray{
    if (!_colorButtonArray) {
        _colorButtonArray = [@[] mutableCopy];
    }
    return _colorButtonArray;
}

- (NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = @[@"FA0300",@"03FF07",@"08DDDB",@"FE6603",@"0057DD",@"FFFFFF",@"FF31AA",@"0"];
    }
    return _colorArray;
}


@end

