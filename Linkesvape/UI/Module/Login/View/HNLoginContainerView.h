//
//  HNLoginContainerView.h
//  Linkesvape
//
//  Created by make on 2017/12/26.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNLoginTextFieldView.h"

@interface HNLoginContainerView : UIView
@property (nonatomic,strong)HNLoginTextFieldView *loginTextFieldView;
@property (nonatomic,strong)HNLoginTextFieldView *pwdTextFieldView;
@property (nonatomic,strong)UIButton *forgetPwdButton;
@property (nonatomic,strong)UIButton *registerButton;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIImageView *logoImageView;
@end
