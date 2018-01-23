//
//  HNPlayListResultViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/10.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNPlayListResultViewController.h"
#import "HNConsoleHistoryListCell.h"
#import "HNPlayListModel.h"

@interface HNPlayListResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HNPlayListResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addToPlayList:(NSString *)modelId{
    NSDictionary *dic = @{@"mode_id":modelId};
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:AddToPlayList requestParameters:dic requestHeader:nil success:^(id responseObject) {
        
        if (CODE == 200) {
            [MBProgressHUD showSuccess:responseObject[@"m"]];
        }else{
            MBErrorMsg;
        }
        
    } faild:^(NSError *error) {
        ERROR;
    }];
}


#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    HNConsoleHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleHistoryListCell3"];
    if (!cell) {
        cell = [[HNConsoleHistoryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleHistoryListCell3"];
    }
    if (self.isHistory == NO) {
        HNPlayListModel *model = self.dataSource[indexPath.row];
        cell.titleLabel.text = model.name;
        
        cell.pressRightBtnBlock = ^{
            [self addToPlayList:model.modelId];
        };
    }else{
        HNPlayModel *model = self.dataSource[indexPath.row];
        cell.titleLabel.text = model.name;
        
        cell.pressRightBtnBlock = ^{
            [self addToPlayList:model.m_id];
        };
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.isHistory == NO) {
        HNPlayListModel *model = self.dataSource[indexPath.row];
        [self addToPlayList:model.modelId];
    }else{
        HNPlayModel *model = self.dataSource[indexPath.row];
        [self addToPlayList:model.m_id];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(40);
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}

#pragma  mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}
@end

