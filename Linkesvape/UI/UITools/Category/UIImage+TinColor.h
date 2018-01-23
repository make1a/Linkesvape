//
//  UIImage+TinColor.h
//  Linkesvape
//
//  Created by make on 2018/1/4.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TinColor)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
