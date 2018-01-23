//
//  HNConsoleHistoryListCell.h
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleHistoryListCell : UITableViewCell
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIButton * rightButton;

@property (nonatomic,copy)void (^pressRightBtnBlock)(void);

@end
