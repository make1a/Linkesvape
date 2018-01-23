//
//  HNLaunchVC.m
//  B2C
//
//  Created by Sunwanwan on 2017/4/10.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNLaunchVC.h"
#import "HNLoginViewController.h"
#import "HNBaseNavigationController.h"

@interface HNLaunchVC () <UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    
    NSInteger firstToSeconedPage;
}

@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, strong) NSMutableArray *mainDataSource;

@end

@implementation HNLaunchVC

+ (instancetype)hnLaunchViewController
{
    HNLaunchVC *viewController = [[HNLaunchVC alloc] init];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    firstToSeconedPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    firstToSeconedPage = (current == 0) ? 0 : firstToSeconedPage;

    if (current == self.mainDataSource.count - 1)
    {
        firstToSeconedPage += 1;

        self.pushBtn.hidden = NO;
        
        // 滑到最后一页，继续滑， 则直接进入登录页
        if (firstToSeconedPage == 2)
        {
            [self passLaunch];
        }
    }
    else
    {
        self.pushBtn.hidden = YES;
    }
}

- (void)passLaunch
{
    mainScrollView.scrollEnabled = NO;
    
    HNLoginViewController *loginVC = [[HNLoginViewController alloc] init];
    HNBaseNavigationController *nav = [[HNBaseNavigationController alloc] initWithRootViewController:loginVC];
    KEY_WINDOW.rootViewController = nav;
    
    [UserDefault setBool:YES forKey:@"firstInstallation"];
    [UserDefault synchronize];
    
}

#pragma mark - setUI

- (void)setUI
{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScrollView.bounces = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    [self.view addSubview:self.pushBtn];
    
    for (int i = 0; i < self.mainDataSource.count; i ++)
    {
        UIImage *image = [UIImage imageNamed:self.mainDataSource[i]];
        UIImageView *imageView = [self imageViewHandleWithImage:image];
        
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, mainScrollView.size.height)];
        contentView.clipsToBounds = YES;
        [contentView addSubview:imageView];
        
        [mainScrollView addSubview:contentView];
    }
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.width * self.mainDataSource.count, mainScrollView.height);
}


// 图片处理
- (UIImageView *)imageViewHandleWithImage:(UIImage *)image
{
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    
    CGFloat sW = SCREEN_WIDTH / imgWidth;
    CGFloat sH = SCREEN_HEIGHT / imgHeight;
    
    CGFloat nowImageWidth;
    CGFloat nowImageHeight;
    
    if (sW > sH)
    {
        nowImageWidth = imgWidth * sW;
        nowImageHeight = imgHeight *sW;
    }
    else
    {
        nowImageWidth = imgWidth *sH;
        nowImageHeight = imgHeight *sH;
    }
    
    CGFloat imageX = (SCREEN_WIDTH - nowImageWidth) / 2;
    CGFloat imageY = (SCREEN_HEIGHT - nowImageHeight) / 2;
    
    UIImageView *imageView = [[UIImageView alloc] init ];
    imageView.frame = CGRectMake(imageX, imageY, nowImageWidth, nowImageHeight);
    imageView.image = image;
    
    return imageView;
}

#pragma mark - getter

- (UIButton *)pushBtn
{
    if(!_pushBtn)
    {
        _pushBtn = InsertImageButton(nil,  CGRectMake((SCREEN_WIDTH - Handle_width(369 / 2)) / 2, SCREEN_HEIGHT - Handle_height(44) - Handle_height(41), Handle_width(369 / 2), Handle_height(41)), 0, nil, nil, self, @selector(passLaunch));
        [_pushBtn setEnlargeEdgeWithTop:15 right:10 bottom:15 left:10];
        _pushBtn.hidden = YES;
    }
    return _pushBtn;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource)
    {
        _mainDataSource = [[NSMutableArray alloc] init];
        
        NSArray *localArray =  @[@"a",@"b",@"c"];
        
        [_mainDataSource addObjectsFromArray:localArray];
    }
    return _mainDataSource;
}

@end
