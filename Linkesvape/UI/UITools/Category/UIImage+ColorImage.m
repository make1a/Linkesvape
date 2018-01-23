//
//  UIImage+ColorImage.m
//  BaseProject
//
//  Created by ZhouChong on 2017/2/23.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage (ColorImage)


+ (UIImage *) imageWithCustomColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
