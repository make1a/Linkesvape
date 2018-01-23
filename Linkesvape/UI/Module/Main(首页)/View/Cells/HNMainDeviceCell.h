//
//  HNMainDeviceCell.h
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

//设备的开关状态
typedef NS_ENUM(NSInteger, HNMainDeviceCellConnectStyle) {
    HNMainDeviceCellConnectOnline ,
    HNMainDeviceCellConnectOffLine
};
//enum {
//    HNMainDeviceCellConnectOnline = 0,
//    HNMainDeviceCellConnectOffLine
//} HNMainDeviceCellConnectStyle;


@interface HNMainDeviceCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headImageView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * statusLabel;
@property (nonatomic,strong)UILabel * powerLabel;
@property (nonatomic,strong)UILabel * persentLabel;
@property (nonatomic,strong)UIButton * connectButton;
@property (nonatomic,copy)void(^pressConnectBlock)(void);


- (void)setCurrentStatusWithStyle:(HNMainDeviceCellConnectStyle)style;
@end
