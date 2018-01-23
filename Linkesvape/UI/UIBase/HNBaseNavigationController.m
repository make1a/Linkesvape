//
//  HNBaseNavigationController.m
//  BaseProject
//
//  Created by mac_111 on 2016/12/5.
//  Copyright © 2016年 HN. All rights reserved.
//

#import "HNBaseNavigationController.h"
#import "UIBarButtonItem+FYExtension.h"

@interface HNBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HNBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationBarHidden = YES;
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    // Do any additional setup after loading the view.
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = CString(@"NavBgColor"); //  导航背景颜色
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attrs[NSForegroundColorAttributeName] = CString(@"NavTitleColor");
    [bar setTitleTextAttributes:attrs];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count>0){
        viewController.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithImage:@"return" highImage:@"" title:nil titleColor:nil target:self action:@selector(NavBack)];
        
        viewController.hidesBottomBarWhenPushed = YES;
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
            self.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
        }
    }
    [super pushViewController:viewController animated:animated];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
}

- (void)NavBack
{
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
