//
//  HNConsoleTableHeadView.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleTableHeadCell.h"
@interface HNConsoleTableHeadCell ()
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)NSArray * buttons;
@end
@implementation HNConsoleTableHeadCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self masLayouySubviews];
    }
    return self;
}


- (void)masLayouySubviews{
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(Handle_width(30));
    }];
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-Handle_width(40));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.leftButton);
        make.height.mas_equalTo(Handle_height(2));
        make.width.mas_equalTo(Handle_width(75));
    }];
}

- (void)clickButton:(UIButton *)sender{
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
    sender.selected = YES;
    
    [UIView animateWithDuration:.3 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(sender);
            make.height.mas_equalTo(Handle_height(2));
            make.width.mas_equalTo(Handle_width(75));
        }];
        [self layoutIfNeeded];
    }];
    
    HNConsoleModelType type;
    if (sender == self.leftButton) {
        type = HNConsoleHistroyModel;
    }else if (sender == self.centerButton){
        type = HNConsoleSystemModel;
    }else{
        type = HNConsoleCustomModel;
    }
    
    if (self.pressButtonBlock) {
        self.pressButtonBlock(type);
    }
    
}

#pragma  mark - 懒加载
- (UIButton *)leftButton
{
    if(!_leftButton)
    {
        UIView *superView = self;
        _leftButton = [[UIButton alloc]init];
        [superView addSubview:_leftButton];
        [_leftButton setTitle:NSLocalizedString(@"历史模式", nil) forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"1d98f2"] forState:UIControlStateSelected];
        _leftButton.selected = YES;
        [_leftButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftButton;
}
- (UIButton *)centerButton
{
    if(!_centerButton)
    {
        UIView *superView = self;
        _centerButton = [[UIButton alloc]init];
        [superView addSubview:_centerButton];
        [_centerButton setTitle:NSLocalizedString(@"系统", nil) forState:UIControlStateNormal];
        [_centerButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_centerButton setTitleColor:[UIColor colorWithHexString:@"1d98f2"] forState:UIControlStateSelected];
        [_centerButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _centerButton;
}
- (UIButton *)rightButton
{
    if(!_rightButton)
    {
        UIView *superView = self;
        _rightButton = [[UIButton alloc]init];
        [superView addSubview:_rightButton];
        [_rightButton setTitle:NSLocalizedString(@"自定义", nil) forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"1d98f2"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIView *)lineView
{
    if(!_lineView)
    {
        UIView *superView = self;
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"1d98f2"];
        [superView addSubview:_lineView];
    }
    return _lineView;
}

- (NSArray *)buttons{
    if (!_buttons) {
        _buttons = @[self.leftButton,self.centerButton,self.rightButton];
    }
    return _buttons;
}
@end
