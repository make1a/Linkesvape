//
//  HNBaseLiveTabBar.h
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/17.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNBaseLiveTabBar;

@protocol HNBaseLiveTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickLiveButton:(HNBaseLiveTabBar *)tabBar;

@end

@interface HNBaseLiveTabBar : UITabBar

@property (nonatomic, assign) id<HNBaseLiveTabBarDelegate> tabbardelegate;

@end
