//
//  BaseViewController.m
//  make
//
//  Created by make on 2017/9/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import "BaseViewController.h"


#define SystemVersionIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)


#ifdef SystemVersionIOS7
#define BASE_TEXTSIZE(text, font) ([text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero)
#else
#define BASE_TEXTSIZE(text, font) ([text length] > 0 ? [text sizeWithFont:font] : CGSizeZero)
#endif
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //顶部不留空
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //取消半透明
    self.navigationController.navigationBar.translucent = NO;
    
    [self masLayoutSubview];
    

    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"2A2B2C"];
    [self setNavigationStyle];
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];


    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];



}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}


- (void)hideNavigationBottomLine{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
}






#pragma mark - --------------------------touch Event--------------------------
- (void)onLeftButtonClick:(id)sender{
    
    if ([self.navigationController.visibleViewController isMemberOfClass:[UITabBarController class]]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)onRightButtonClick:(id)sender{
    
    
    
}

- (void)refreshEvent{
    
    
}


#pragma mark - 设置NavigationTitle
- (void)setNavigationTitle:(NSString *)title {
    
    self.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}
#pragma mark - 左侧按钮设置
- (void)setLeftButtonTitle:(NSString *)title{
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setFrame:CGRectMake(0, 0, BASE_TEXTSIZE(title, self.leftButton.titleLabel.font).width, BASE_TEXTSIZE(title,self.leftButton.titleLabel.font).height)];
}
- (void)setLeftButtonImage:(UIImage *)image{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
}
#pragma mark - 右侧按钮设置
- (void)setRightButtonTitle:(NSString *)title{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setFrame:CGRectMake(0, 0, BASE_TEXTSIZE(title, self.rightButton.titleLabel.font).width, BASE_TEXTSIZE(title,self.rightButton.titleLabel.font).height)];
    
    
}
- (void)setRightButtonImage:(UIImage *)image{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton setFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
    
    
    
}

#pragma mark - --------------------------overwirte--------------------------
-(void)touchesEnded:(NSSet<UITouch*> *)touches withEvent:(UIEvent*)event{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//点击屏幕收起键盘
    
}

/**
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 状态栏变白 要设置info.plist View controller-based status bar appearance  为NO
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - --------------------------lazy load--------------------------
- (UIButton *)leftButton{
    
    if (!_leftButton) {
        
        _leftButton = [[UIButton alloc]init];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_leftButton setExclusiveTouch:YES];
        [_leftButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_leftButton addTarget:self action:@selector(onLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _leftButton;
    
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [[UIButton alloc]init];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_rightButton setExclusiveTouch:YES];
        [_rightButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_rightButton addTarget:self action:@selector(onRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _rightButton;
    
}


- (void)setNavigationStyle{
    
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)loadData
{
    
}

#pragma mark - 加载空界面

- (HNBaseBankView *)baseBankView
{
    if (!_baseBankView)
    {
        _baseBankView = [[HNBaseBankView alloc] init];
    }
    return _baseBankView;
}

- (HNBaseBankView *)loadAbankViewWithSuperView:(UIView *)superView frame:(CGRect)frame imageStr:(NSString *)imageStr descStr:(NSString *)descStr
{
    self.baseBankView.frame = frame;
    [superView addSubview:self.baseBankView];
    
    self.baseBankView.iconImg.image = [UIImage imageNamed:imageStr];
    self.baseBankView.descLab.text = descStr;
    return self.baseBankView;
}
- (void)dealloc
{
    DLog(@"=============================释放了");
}
#pragma mark - --------------------------Masonry--------------------------
- (void)masLayoutSubview{
    
}


@end

