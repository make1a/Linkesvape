//
//  HNHNBaseViewController.m
//  BaseProject
//
//  Created by mac_111 on 2016/12/5.
//  Copyright © 2016年 HN. All rights reserved.
//

#import "HNBaseViewController.h"


@interface HNBaseViewController ()

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
@end

@implementation HNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CString(BgColor);
    
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

- (void)loadAbankViewWithSuperView:(UIView *)superView frame:(CGRect)frame imageStr:(NSString *)imageStr descStr:(NSString *)descStr
{
    self.baseBankView.frame = frame;
    [superView addSubview:self.baseBankView];
    
    self.baseBankView.iconImg.image = [UIImage imageNamed:imageStr];
    self.baseBankView.descLab.text = descStr;
}
- (void)dealloc
{
    DLog(@"=============================释放了");
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
