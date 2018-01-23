//
//  HNConsoleTableHeadView.h
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleTableHeadCell : UITableViewCell
@property (nonatomic,strong)UIButton * leftButton;
@property (nonatomic,strong)UIButton * centerButton;
@property (nonatomic,strong)UIButton * rightButton;


@property (nonatomic,copy) void(^pressButtonBlock)(HNConsoleModelType type);

@end
