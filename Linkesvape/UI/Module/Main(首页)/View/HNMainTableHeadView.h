//
//  HNMainTableHeadView.h
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNMainTableHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;
@property (nonatomic,copy)void (^pressRightButtonBlock)(void);

@end
