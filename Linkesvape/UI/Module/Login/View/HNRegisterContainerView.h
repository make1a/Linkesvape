//
//  HNRegisterContainerView.h
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNRegisterTextfieldView.h"
@interface HNRegisterContainerView : UIView
@property (nonatomic,strong)HNRegisterTextfieldView *userNameView;
@property (nonatomic,strong)HNRegisterTextfieldView *registerCodeView;
@property (nonatomic,strong)HNRegisterTextfieldView *pwdView;
@property (nonatomic,strong)HNRegisterTextfieldView *actionPwdView;
@property (nonatomic,strong)UIButton *sumbitButton;
@property (nonatomic,strong)UIButton *xyButton;
@end
