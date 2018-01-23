//
//  HNMainContainerView.h
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNMainContainerView : UIView<SDCycleScrollViewDelegate>
@property (nonatomic,strong)SDCycleScrollView *adScrollerView;
@property (nonatomic,strong)UITableView *tableView;
@end
