//
//  UIImage+ColorImage.h
//  BaseProject
//
//  Created by ZhouChong on 2017/2/23.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)

/*
 * 利用颜色创建一个image
 */
+ (UIImage *) imageWithCustomColor:(UIColor *)color;

@end
