//
//  HNSkinThemeManager.m
//  OptimalLive
//
//  Created by Sunwanwan on 2017/9/27.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNSkinThemeManager.h"

static HNSkinThemeManager *skinThemeManager;
static NSString* kStyle_Content = @"Content";

@interface HNSkinThemeManager ()
{
    NSDictionary *configrationDict;
}

@end

@implementation HNSkinThemeManager

+ (HNSkinThemeManager *)shareSkinThemeManager
{
    @synchronized (self)
    {
        if (!skinThemeManager)
        {
            skinThemeManager = [[HNSkinThemeManager alloc] init];
        }
    }
    
    return skinThemeManager;
}

- (id)init
{
    if (self = [super init])
    {
        NSString * themePath = [[NSBundle mainBundle] pathForResource:@"SkinTheme" ofType:@"plist"];
        
        NSAssert(themePath, @"SkinTheme.plist can't find.");
        
        configrationDict = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        [self getAppSkinTheme];
    }
    
    return self;
}

#pragma mark - privateMethod

- (NSArray<NSString *> *)skinThemeList
{
    return configrationDict.allKeys;
}

// 获取对应key中对应格式的content  例如： 获取white主题下的背景色的Content
- (UIColor *)skinColorStringWithKey:(NSString *)lstr
{
    NSDictionary<NSString*, NSDictionary*> *skinStringDict = configrationDict[_currentTheme];
    
    if ( [skinStringDict[@"Colors"].allKeys containsObject:lstr] )
    {
        return [HNSkinThemeManager colorWithHexString:skinStringDict[@"Colors"][lstr][kStyle_Content]];
    }
    
    DLog(@"can't find locationStringKey : %@ in lang config : %@", lstr, _currentTheme);
    return UIColorFromHEXA(0xffffff, 1.0);
}

// 获取对应主题下对应图片的名称  例如：获取white主题下账单明细的图片名称
- (NSString *)skinImageNameWithKey:(NSString *)lstr
{
    NSDictionary<NSString*, NSDictionary*> *skinStringDict = configrationDict[_currentTheme];
    
    if ( [skinStringDict[@"Images"].allKeys containsObject:lstr] )
    {
        return skinStringDict[@"Images"][lstr][kStyle_Content];
    }
    
    DLog(@"can't find locationStringKey : %@ in lang config : %@", lstr, _currentTheme);
    return @"";
}

// 获取或重置当前app主题
- (NSString *)getAppSkinTheme
{
     NSString *lastUserSkinThemeKey = [[NSUserDefaults standardUserDefaults] stringForKey:LastUserSkinThemeInSandBox];
    
    if (lastUserSkinThemeKey == nil)
    {
        _currentTheme = @"white";
    }
    else
    {
        // 当前沙盒中保存的主题色
        _currentTheme = lastUserSkinThemeKey;
    }
    
    return _currentTheme;
}

- (void)changeSkinThemeWithThemeStr:(NSString *)themeStr
{
    _currentTheme = themeStr;
    
    [[NSUserDefaults standardUserDefaults] setObject:themeStr forKey:LastUserSkinThemeInSandBox];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - PrivateMethod

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    UIColor *DEFAULT_VOID_COLOR = [UIColor clearColor];
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    NSString *alpha = @"FF";
    if([cString length] == 8){
        alpha = [cString substringToIndex:2];
        cString = [cString substringFromIndex:2];
    }
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b,a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:alpha] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}


@end
