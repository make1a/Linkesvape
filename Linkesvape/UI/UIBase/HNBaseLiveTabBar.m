//
//  HNBaseLiveTabBar.m
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/17.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNBaseLiveTabBar.h"

@interface HNBaseLiveTabBar ()

@property (nonatomic, strong) UIButton *liveBtn;

@end

@implementation HNBaseLiveTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        // 添加一个按钮到tabbar中
        UIButton *liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [liveBtn setImage:[UIImage imageNamed:@"nor_camera"] forState:UIControlStateNormal];
        liveBtn.size = liveBtn.currentImage.size;
        [liveBtn addTarget:self action:@selector(liveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:liveBtn];
        self.liveBtn = liveBtn;
    }
    return self;
}

/**
 *  直播按钮点击
 **/
- (void)liveBtnClick
{
    if ([self.tabbardelegate respondsToSelector:@selector(tabBarDidClickLiveButton:)])
    {
        [self.tabbardelegate tabBarDidClickLiveButton:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1, 设置直播按钮的位置
    self.liveBtn.centerX = self.width * 0.5;
    self.liveBtn.centerY = self.height *0.5;
    
    // 2, 设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews)
    {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class])
        {
            child.width = tabbarButtonW;
            child.x = tabbarButtonIndex * tabbarButtonW;
            
            // 增加索引
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2)
            {
                tabbarButtonIndex ++;
            }
        }
    }
}

@end
