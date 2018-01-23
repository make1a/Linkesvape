//
//  AppDelegate.m
//  Linkesvape
//
//  Created by make on 2017/12/26.
//  Copyright © 2017年 make. All rights reserved.
//

#import "AppDelegate.h"
#import "HNBaseNavigationController.h"
#import "HNLoginViewController.h"
#import "HNMainViewController.h"
#import "HNBaseLiveTabBarController.h"
#import "HNLaunchVC.h"
#import "AppDelegate+StarLogic.h"

@interface AppDelegate ()
@property (nonatomic, strong) HNAlertView *hasLoginView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    // 自动管理键盘配置
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    
    // 保存手机唯一标识符
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSArray* array = [identifierForVendor componentsSeparatedByString:@"-"];
    NSMutableString* strM = [NSMutableString string];
    for (NSString* str in array) {
        [strM appendString:str];
    }
    [[NSUserDefaults standardUserDefaults] setObject:strM forKey:@"UDID"];
    
    
    
    [self checkLanguage];

    [self autoLogin];
    
    
    BOOL firstInstallation = [[UserDefault objectForKey:@"firstInstallation"] boolValue];
    
    if (!firstInstallation)
    {
        //检查系统语言
        HNLaunchVC *vc = [HNLaunchVC hnLaunchViewController];
        self.window.rootViewController = vc;
    }else{
        [self setRootViewController];

    }
    // 在其他手机上登录， 被挤掉了ew
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogin) name:@"hasLogin" object:nil];
    [self checkVersion];
    [self bluetoothDelegate];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setRootViewController{
    if (kUserID == nil || [kUserID isEqualToString:@""]){
        HNLoginViewController *loginVC = [HNLoginViewController new];
        HNBaseNavigationController *nav = [[HNBaseNavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }else{
        HNBaseLiveTabBarController *vc = [[HNBaseLiveTabBarController alloc] init];
        self.window.rootViewController = vc;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma  mark - BLEAction
- (void)bluetoothDelegate{
    [[HNBLEConnectManager shareInstance] scan]; //开始扫描
}
#pragma mark - 被挤掉
- (void)hasLogin
{
    
    [[HNUserModel shareInstance] clear];
    
    // 清除本地保存的userID, 清除掉本地保存的未读消息数
    [UserDefault setValue:@"" forKey:@"userId"];
    [UserDefault synchronize];
    
    HNLoginViewController *vc = [[HNLoginViewController alloc] init];
    HNBaseNavigationController *nav = [[HNBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.hasLoginView showAlertView:nil];
    
}


#pragma mark - 自动登录

- (void)autoLogin
{
    if (kUserID == nil || [kUserID isEqualToString:@""])
    {
        // 说明手动退出登录
        return;
    }
    
    NSDictionary *dic = @{
                          @"uid" : kUserID,
                          @"uniqueid" : kUDID ? kUDID : @""
                          };
    
    NSDictionary *header = @{@"authorization" : kTOKEN ? kTOKEN : @""};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:AutoLogin requestParameters:dic requestHeader:header success:^(id responseObject) {
        
        if (CODE == 200)
        {
            // 自动登录成功
            HNUserModel *model = [HNUserModel shareInstance];
            model = [HNUserModel yy_modelWithJSON:responseObject[@"d"][@"account_info"]];
            [HNUserModel shareInstance].uid = model.uid;
            NSString *token = responseObject[@"d"][@"token"];
            [UserDefault setValue:token forKey:@"token"];
            [UserDefault synchronize];
 
            HNBaseLiveTabBarController *vc = [[HNBaseLiveTabBarController alloc] init];
            self.window.rootViewController = vc;

        }
        
    } faild:^(NSError *error) {
        ERROR;
    }];
}
#pragma mark - getter

- (HNAlertView *)hasLoginView
{
    if (!_hasLoginView)
    {
        NSDate* date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        
        NSString *str = [NSString stringWithFormat:@"您的账号于%@在另一台手机登录,如非本人操作,则密码可能已经泄露，建议修改密码。",timeStr];
        
        _hasLoginView = [[HNAlertView alloc] initWithTitle:@"提示" Content:str whitTitleArray:@[@"好"] withType:@"center"];
        _hasLoginView.tag = 1111;
    }
    
    return _hasLoginView;
}

@end
