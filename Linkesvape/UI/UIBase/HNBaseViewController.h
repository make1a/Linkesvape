//
//  HNHNBaseViewController.h
//  BaseProject
//
//  Created by mac_111 on 2016/12/5.
//  Copyright © 2016年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBaseBankView.h"

@interface HNBaseViewController : UIViewController

@property (nonatomic, strong) HNBaseBankView *baseBankView;

- (void)loadAbankViewWithSuperView:(UIView *)superView frame:(CGRect)frame imageStr:(NSString *)imageStr descStr:(NSString *)descStr;
@end
