//
//  UIButton+HNAddBadge.m
//  OptimalLive
//
//  Created by Sunwanwan on 2017/9/18.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "UIButton+HNAddBadge.h"

@implementation UIButton (HNAddBadge)

//显示红点
- (void)showBadge
{
    [self removeBadge];
    
    //新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 888;
    bview.layer.cornerRadius = 5;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect btnFrame = self.frame;
    
    float percentX = 0.8;
    CGFloat x = ceilf(percentX*btnFrame.size.width);
    CGFloat y = ceilf(0.1*btnFrame.size.height);
    bview.frame = CGRectMake(x, y - 2.5, 10, 10);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}

//隐藏红点
- (void)hideBadge
{
    [self removeBadge];
}

//移除控件
- (void)removeBadge
{
    for (UIView*subView in self.subviews)
    {
        if (subView.tag == 888)
        {
            [subView removeFromSuperview];
        }
    }
}

@end
