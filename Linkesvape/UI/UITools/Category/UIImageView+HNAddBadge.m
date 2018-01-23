//
//  UIImageView+HNAddBadge.m
//  OptimalLive
//
//  Created by Sunwanwan on 2017/9/7.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "UIImageView+HNAddBadge.h"

@implementation UIImageView (HNAddBadge)

//显示红点
- (void)showBadgeWithCount:(NSString *)count
{
    [self removeBadge];
    
    //新建小红点
    UILabel *bLabel = [[UILabel alloc]init];
    bLabel.tag = 888;
    bLabel.layer.cornerRadius = 5;
    bLabel.clipsToBounds = YES;
    bLabel.backgroundColor = [UIColor redColor];
    bLabel.font = SystemFontSize(8);
    bLabel.textColor = [UIColor whiteColor];
    bLabel.text = count;
    
    if ([count integerValue] > 99)
    {
        bLabel.text = @"99+";
    }
    
    CGRect rect = [HNTools getStringFrame:count withFont:4 withMaxSize:CGSizeMake(Handle_width(20), Handle_height(10))];
    
    CGRect imageFrame = self.frame;
    
    CGFloat x = imageFrame.origin.x + imageFrame.size.width - 3;
    CGFloat y = imageFrame.origin.y - 3;
    
    bLabel.frame = CGRectMake(x, y, rect.size.width + 5, rect.size.height + 5);
    
    [self addSubview:bLabel];
    [self bringSubviewToFront:bLabel];
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
