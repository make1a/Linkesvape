//
//  UIBarButtonItem+FYExtension.m
//  百思不得姐
//
//  Created by fengyang on 16/7/7.
//  Copyright © 2016年 fengyang. All rights reserved.
//

#import "UIBarButtonItem+FYExtension.h"
#import "UIView+HNExtension.h"

@implementation UIBarButtonItem (FYExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    if (titleColor == nil) {
        [button setTitleColor:UIColorFromHEXA(0x333333, 1.0) forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.size = button.currentBackgroundImage.size;
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+(instancetype)leftItemWithImage:(NSString*)image higthImage:(NSString*)hightImage title:(NSString*)title target:(id)target action:(SEL)action;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    // 让按钮根据图片和文字的宽自适应
    //  [button sizeToFit];
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 微调button在导航条上的位置
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
