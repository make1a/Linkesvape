//
//  UIButton+EnlargeEdge.h
//  BaseProject
//
//  Created by ZhouChong on 2017/2/24.
//  Copyright © 2017年 HN. All rights reserved.
//  扩大按钮点击范围

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
