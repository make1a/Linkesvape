//
//  HNBaseLiveTabBarController.m
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/17.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNBaseLiveTabBarController.h"
#import "HNBaseNavigationController.h"
#import "HNMainViewController.h"
#import "HNBaseLiveTabBar.h"
#import "HNSettingMainViewController.h"
#import "HNConsoleMainViewController.h"
#import "HNOTAViewController.h"
//#import "HNCertificationResultVC.h"

@interface HNBaseLiveTabBarController ()<HNBaseLiveTabBarDelegate>

@end

@implementation HNBaseLiveTabBarController

+(void)initialize
{
    //     tabBaritme 标题未选中的 颜色 大小设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    attrs[NSForegroundColorAttributeName] = attrs[NSForegroundColorAttributeName];
    
    //     tabBaritme 标题选中的 颜色 大小设置
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"1d98f2"];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChildVC:[[HNMainViewController alloc]init] title:NSLocalizedString(@"首页", nil) image:@"home_noseleter" selectedImage:@"home"];
    [self setupChildVC:[[HNOTAViewController alloc]init] title:NSLocalizedString(@"控制台", nil) image:@"console_noseleter" selectedImage:@"console"];
    [self setupChildVC:[[HNSettingMainViewController alloc]init] title:NSLocalizedString(@"设置", nil) image:@"setting_noseleter" selectedImage:@"setting"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


/**
 *   设置tabBar子控制器 item 标题，以及图片
 *
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    HNBaseNavigationController  *nav = [[HNBaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}






@end
