//
//  HNConsoleMainHeadView.h
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleMainHeadView : UIView
@property (nonatomic,strong)UIButton * rightButton; //topview右边按钮
@property (nonatomic,strong)UIButton * leftButton; //topview左边按钮
@property (nonatomic,strong)UIButton * pageUpButton;
@property (nonatomic,strong)UIButton * pageDownButton;
@property (nonatomic,strong)UILabel * pageLabel;

@property (nonatomic,copy)void (^pressRightButtonBlock)(void);

@end
