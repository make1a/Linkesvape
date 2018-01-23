//
//  HNMainContainerView.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainContainerView.h"

@implementation HNMainContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self masLayoutSubViews];
    }
    return self;
}

- (void)masLayoutSubViews{
    [self adScrollerView];
    [self.adScrollerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(Handle_height(125));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.adScrollerView.mas_bottom).mas_offset(Handle_height(13));
    }];
    
}

#pragma mark - 懒加载
- (SDCycleScrollView *)adScrollerView
{
    if (!_adScrollerView)
    {
        _adScrollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Handle_height(125)) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_loading"]];
        _adScrollerView.localizationImageNamesGroup = @[@"home_banner_loading",@"home_banner_loading",@"home_banner_loading",@"home_banner_loading",@"home_banner_loading"];
        _adScrollerView.autoScrollTimeInterval = 4;
        _adScrollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _adScrollerView.currentPageDotColor = [UIColor whiteColor];
        _adScrollerView.pageDotColor = [UIColor colorWithHexString:@"FFFFFF" alpha:.5];
        _adScrollerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        [self addSubview:_adScrollerView];
    }
    return _adScrollerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    return _tableView;
}
@end
