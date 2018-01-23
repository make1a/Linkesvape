//
//  HNSkinThemeManager.h
//  OptimalLive
//
//  Created by Sunwanwan on 2017/9/27.
//  Copyright © 2017年 HN. All rights reserved.
//  皮肤主题管理类

#import <Foundation/Foundation.h>

// 保存最后一次使用的皮肤配置
#define LastUserSkinThemeInSandBox @"LastUserSkinThemeInSandBox"

@interface HNSkinThemeManager : NSObject

// 当前使用的皮肤主题
@property (nonatomic, copy) NSString *currentTheme;

+ (HNSkinThemeManager *)shareSkinThemeManager;


// 获取主题列表
- (NSArray<NSString *>*)skinThemeList;

// 获取对应主题色下中对应格式的content  例如： 获取white主题下的背景色的Content
- (UIColor *)skinColorStringWithKey:(NSString *)lstr;

// 获取对应主题下对应图片的名称  例如：获取white主题下账单明细的图片名称
- (NSString *)skinImageNameWithKey:(NSString *)lstr;

// 切换主题
- (void)changeSkinThemeWithThemeStr:(NSString *)themeStr;

// 获取或重置当前app主题
- (NSString *)getAppSkinTheme;

@end
