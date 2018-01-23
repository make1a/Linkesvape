//
//  Macros.h
//  OptimalLive
//
//  Created by Sunwanwan on 2017/8/31.
//  Copyright © 2017年 HN. All rights reserved.
//  整个项目的一些宏定义处理

#ifndef Macros_h
#define Macros_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define _weakself __weak typeof(self) weakself = self

// 颜色
#define UIColorFromHEXA(hex,a) [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0f green:((hex & 0xFF00) >> 8) / 255.0f blue:(hex & 0xFF) / 255.0f alpha:a]
#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 系统默认字体设置和自选字体设置
#define SystemFontSize(fontsize) [UIFont systemFontOfSize:(fontsize)]
#define SystemBoldFontSize(fontsize) [UIFont boldSystemFontOfSize:(fontsize)]
#define CustomFontSize(fontname,fontsize) [UIFont fontWithName:fontname size:fontsize]

//获取图片资源
#define GetImage(imageName)    [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define imageDomain(imageName) [NSString stringWithFormat:@"%@/upload/%@", REQUEST,imageName]

// 等比例缩放系数
#define KEY_WINDOW    ([UIApplication sharedApplication].keyWindow)
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_SCALE  ((SCREEN_WIDTH > 414) ? (SCREEN_HEIGHT/375.0) : (SCREEN_WIDTH/375.0))
#define Handle(x)        ((x)*SCREEN_SCALE)
#define Handle_width(w)  ((w)*SCREEN_SCALE)
#define Handle_height(h) ((h)*SCREEN_SCALE)

// 网络状态
#define NetWork_MobileNet  @"MobileNet" //3G|4G
#define NetWork_WIFI       @"WIFI" //WIFI
#define NetWork_NONET      @"NONET" //NONET
#define NetworkChangeNotification @"NetworkChangeNotification"

#pragma mark --------------------------protocal----------------------------

// 通用控件左右间隔
#define kSpaceToLeftOrRight Handle(10)

// 底部条高度
#define kBottomViewHeight 48

// 导航条高度
#define  kNavigationHeight 64

#define ChatToolsHeight  49             // 聊天工具框高度
#define EmojiKeyboard_Height 238        // 表情键盘的高度
#define LiveChatToolsHeight 64          // 直播间聊天工具栏高度

#pragma mark ------------------------- 项目相关 ------------------------------------

typedef enum : NSUInteger {
    HNConsoleHistroyModel,
    HNConsoleSystemModel,
    HNConsoleCustomModel,
} HNConsoleModelType;



#define CODE            [[responseObject objectForKey:@"c"] integerValue]
#define ERROR           [MBProgressHUD showError:NSLocalizedString(@"加载失败", nil)]
#define MBErrorMsg      [MBProgressHUD showError:responseObject[@"m"]]
#define MBShow          [MBProgressHUD showHUDAddedTo:self.view animated:YES]
#define MBHidden        [MBProgressHUD hideHUDForView:self.view animated:YES]
#define SuccessCode     200

#define kWebSocketUrl  @"websocketUrl"
#define Type(name)     [messageDict[@"type"] isEqualToString:name] 

#define kChangeTotalUnread  @"changeUnread"
#define kUnReadKey          @"total_unread"   // 发未读消息通知时unserInfo里的key值
#define UnreadMessageCount  @"unread_count"   // 保存在本地的未读消息总数

#define kSearchHistoryData @"searchHistory"

#define kSkinType       @"skinType"       // 美颜类型
#define kSkincareValue  @"skincareValue"  // 美颜值
#define kWhiteningValue @"whiteningValue" // 美白值
#define kRuddyValue     @"ruddyValue"     // 红润值

//#define pxHeight1334(a) a*SCREEN_HEIGHT/1334.f
//#define pxWidth750(a) a*SCREEN_WIDTH/750.f
#pragma mark ------------------------  用户相关 ------------------------------------

#define kACCOUNT  @"account"

#define kUserID   [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
#define kUDID     [[NSUserDefaults standardUserDefaults]objectForKey:@"UDID"]
#define kTOKEN    [[NSUserDefaults standardUserDefaults]objectForKey:@"token"]

#define UserDefault [NSUserDefaults standardUserDefaults]

#pragma mark -------------------------  工程配置相关 --------------------

#define myAvatar [[NSUserDefaults standardUserDefaults]objectForKey:@"myAvatar"]

#define kCoinName [[NSUserDefaults standardUserDefaults]objectForKey:@"coin"]
#define kDotName  [[NSUserDefaults standardUserDefaults]objectForKey:@"dot"]
#define kIDName [[NSUserDefaults standardUserDefaults]objectForKey:@"account_name"]
#define kFreeSeeTime [[NSUserDefaults standardUserDefaults]objectForKey:@"free_time"]  // 免费观看时间
#define kSayLevel [[NSUserDefaults standardUserDefaults]objectForKey:@"say_level"]  // 发言等级
#define kAppName  @"优播"
#define kAppIcon  GetImage(@"main_logo")

// 获取本地版本号
#define kBundleVersionNumber [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 获取本地数字版本号
#define VersionNumber [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

#define kGiftVersionTime  [[NSUserDefaults standardUserDefaults]objectForKey:@"gift_version_time"]  // 礼物版本更新时间

#define DefaultHeaderImage GetImage(@"home_head_default")

#define CString(k)  [[HNSkinThemeManager shareSkinThemeManager] skinColorStringWithKey:k]
#define ImageString(k)  [[HNSkinThemeManager shareSkinThemeManager] skinImageNameWithKey:k]
#define CurrentThemeIsWhite [[[HNSkinThemeManager shareSkinThemeManager] getAppSkinTheme] isEqualToString:@"white"]

// 主色调
#define MainColor        @"MainColor"

// 背景色
#define BgColor          @"BgColor"

// 分割线
#define  LineColor       @"LineColor"

// 标题颜色
#define TitleColor       @"TitleColor"

// 副标题颜色
#define SubtitleColor    @"SubtitleColor"

// 内容颜色
#define ContentColor     @"ContentColor"

// 白色文字
#define WhiteColor       @"WhiteColor"

// 按钮可点击状态
#define BtnBgColor            UIColorFromHEXA(0x920CDC,1.0)




#endif /* Macros_h */
