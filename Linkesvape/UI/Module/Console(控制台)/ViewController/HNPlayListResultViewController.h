//
//  HNPlayListResultViewController.h
//  Linkesvape
//
//  Created by make on 2018/1/10.
//  Copyright © 2018年 make. All rights reserved.
//

#import "BaseViewController.h"

@interface HNPlayListResultViewController : BaseViewController
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)BOOL isHistory;

@end
