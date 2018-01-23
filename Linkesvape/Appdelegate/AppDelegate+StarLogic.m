//
//  AppDelegate+StarLogic.m
//  Linkesvape
//
//  Created by make on 2018/1/16.
//  Copyright © 2018年 make. All rights reserved.
//

#import "AppDelegate+StarLogic.h"

@implementation AppDelegate (StarLogic)
- (void)checkVersion
{
    // 获取下上次礼物版本的更新时间
    NSString *versionTime;
    if (kGiftVersionTime == nil)
    {
        versionTime = @"0";
    }
    else
    {
        versionTime = kGiftVersionTime;
    }
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:CheckVersion requestParameters:@{@"os" : @"iOS",@"version_time" : versionTime} requestHeader:nil success:^(id responseObject) {
        
        if (CODE != 200)
        {
            return ;
        }
        // 版本更新处理
        
        //        // 对版本号进行比较
        //        NSString *version = responseObject[@"d"][@"app_version"][@"version"];
        //        NSString *currentVersion = kBundleVersionNumber;
        
        // 对数字版本号进行比较
        NSString *versionNumber = responseObject[@"d"][@"app_version"][@"number"];
        NSString *currentVersion = VersionNumber;
        
        if ([versionNumber compare:currentVersion] == NSOrderedDescending)
        {
            // 如果当前服务器的版本号跟系统的版本号大
            BOOL firstInstallation = [[UserDefault objectForKey:@"firstInstallation"] boolValue];
            if (firstInstallation == YES)
            {
                // 先判断是否强制更新
                if ([responseObject[@"d"][@"app_version"][@"is_force_update"] integerValue] == 1)
                {
                    // 强制更新
                    NSDictionary *dic = responseObject[@"d"][@"app_version"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showVersionAlert" object:@"YES" userInfo:dic];
                }
                else
                {
                    if ([responseObject[@"d"][@"app_version"][@"extra_info"] boolValue] == YES)
                    {
                        // 开启了版本检测更新之后，才会弹出更新提示框
                        NSDictionary *dic = responseObject[@"d"][@"app_version"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"showVersionAlert" object:nil userInfo:dic];
                    }
                }
            }
        }
        
        
    } faild:^(NSError *error) {
        ;
    }];
}

- (void)checkLanguage{
    //保存语言
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] valueForKey:HNUserDefaultLanguage];
    
    if ([currentLanguage containsString:@"en"]){
        currentLanguage = @"en";
    }else{
        currentLanguage = @"zh-Hans";
    }

    [NSBundle setLanguage:currentLanguage];
}
@end
