//
//  HNMainAddDeviceCell.h
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNMainAddDeviceCell : UITableViewCell
@property (nonatomic,strong)UIButton * addDeviceButton;

@property (nonatomic,copy)void (^pressAddBtnBlock)(void);

@end
