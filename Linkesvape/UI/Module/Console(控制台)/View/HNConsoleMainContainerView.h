//
//  HNConsoleMainContainerView.h
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleMainContainerView : UIView
/** topView **/
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIButton * rightButton; //topview右边按钮
@property (nonatomic,strong)UIButton * leftButton; //topview左边按钮
@property (nonatomic,strong)UIButton * pageUpButton;
@property (nonatomic,strong)UIButton * pageDownButton;
@property (nonatomic,strong)UILabel * pageLabel;



@end
