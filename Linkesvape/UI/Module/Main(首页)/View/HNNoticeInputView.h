//
//  HNNoticeInputView.h
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNNoticeInputView : UIView
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UITextField * textfield;
@property (nonatomic,strong)UIButton * sumbitButton;
@property (nonatomic,strong)UIButton * cancelButton;

@property (nonatomic,copy)void (^pressSumbitButtonBlock)(void);

@end
