//
//  HNConsoleListCell.h
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleListCell : UITableViewCell
@property (nonatomic,strong)UILabel * numberLabel;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UIButton * rightButton;

@property (nonatomic,copy)void (^pressAddButtonBlock)(void);

@end
