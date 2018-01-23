//
//  HNMainAddDeviceCell.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainAddDeviceCell.h"

@implementation HNMainAddDeviceCell
#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self masLayoutSubview];
    }
    return self;
}

#pragma  mark - 点击
- (void)clickButton{
    if (self.pressAddBtnBlock) {
        self.pressAddBtnBlock();
    }
}


#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

#pragma  mark - 懒加载
- (UIButton *)addDeviceButton
{
    if(!_addDeviceButton)
    {
        UIView *superView = self.contentView;
        _addDeviceButton = [[UIButton alloc]init];
        [superView addSubview:_addDeviceButton];
        [_addDeviceButton setTitle:NSLocalizedString(@"添加新设备", nil) forState:UIControlStateNormal];
        [_addDeviceButton setTitleColor:[UIColor colorWithHexString:@"1D98F2"] forState:UIControlStateNormal];
        _addDeviceButton.titleLabel.font = [UIFont systemFontOfSize:Handle_height(14)];
        [_addDeviceButton setImage:[UIImage imageNamed:@"add_address"] forState:UIControlStateNormal];
        [_addDeviceButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addDeviceButton;
}

@end
