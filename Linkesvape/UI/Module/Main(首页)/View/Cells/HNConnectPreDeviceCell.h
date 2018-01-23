//
//  HNConnectPreDeviceCell.h
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConnectPreDeviceCell : UITableViewCell

@property (nonatomic,strong)UILabel * headTitleLabel;
@property (nonatomic,strong)UIButton * editorButton;

@property (nonatomic,copy) void(^pressEditorButton)(void);


- (void)cellRefreshWithAlertName:(HNBleDeviceModel *)model;
@end
