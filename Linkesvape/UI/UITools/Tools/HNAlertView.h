//
//  HNAlertView.h
//  HNShop
//
//  Created by fengyang on 17/1/10.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^alertBlock)(NSInteger index);

@interface HNAlertView : UIView

@property (nonatomic, copy) alertBlock myBlock;
@property (nonatomic, strong) NSString   *type;

- (instancetype)initWithTitle:(NSString *)title Content:(NSString *)contentStr whitTitleArray:(NSArray *)titleArray withType:(NSString *)type;

- (void)showAlertView:(alertBlock)myBlock;

- (void)dissmis;

// 针对退出登录视图额外做的处理
@property (nonatomic, assign) BOOL isLoginOut;

@end
