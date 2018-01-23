//
//  HNConsoleMainViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNConsoleMainViewController.h"
#import "HNPayListViewController.h"
#import "HNConsoleHistroyViewController.h"
#import "HNConsoleCustomViewController.h"
#import "HNConsoleSystemViewController.h"

//views
#import "HNConsoleTableHeadCell.h"
#import "HNConsoleMainHeadView.h"
#import "HNTableHedView.h"
#import "HNSettingsCell.h"
#import "HNConsoleListCell.h"

//Model
#import "HNPlayListModel.h"



@interface HNConsoleMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)HNConsoleMainHeadView * headView;
@property (nonatomic,assign)HNConsoleModelType  type;

@property (nonatomic,strong)NSMutableArray * historyDataSource;
@property (nonatomic,strong)NSMutableArray * systemDataSource;
@property (nonatomic,strong)NSMutableArray * customDataSource;
@end

@implementation HNConsoleMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = HNConsoleHistroyModel;
    [self requestPlayList];
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"控制台", nil)];
}

#pragma  mark- 数据
- (void)requestPlayList{
    
    NSString *type;
    
    if (self.type == HNConsoleCustomModel) {
        type = @"custom";
    }else if (self.type == HNConsoleSystemModel){
        type = @"system";
    }else{
        [self requestHistoryList];
        return;
    }
    
    NSDictionary *dic = @{@"type":type};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:ModelList requestParameters:dic requestHeader:nil success:^(id responseObject) {
        
        DLog(@"responseObject==%@",responseObject);
        if (CODE==200) {
            
            [self.systemDataSource removeAllObjects];
            [self.historyDataSource removeAllObjects];
            [self.customDataSource removeAllObjects];
            
            NSArray *array = responseObject[@"d"][@"list"][@"items"];
            
            for (NSDictionary *d in array) {
                
                HNPlayListModel *model = [HNPlayListModel yy_modelWithDictionary:d];
                
                if (self.type == HNConsoleCustomModel) { //自定义
                    
                    [self.customDataSource addObject:model];
                    
                }else if (self.type == HNConsoleSystemModel){ //系统模式
                    
                    [self.systemDataSource addObject:model];
                    
                }
            }
            [self.tableView reloadData];
        }else{
            MBErrorMsg;
            [self.tableView reloadData];
        }

    } faild:^(NSError *error) {
        ERROR;
    }];
    
}
- (void)requestHistoryList{
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:HistoryModelList requestParameters:nil requestHeader:nil success:^(id responseObject) {
        
        DLog(@"responseObject==%@",responseObject);
        if (CODE == 200) {
            [self.historyDataSource removeAllObjects];
            
            NSArray *array = responseObject[@"d"][@"list"];
            
            for (NSDictionary *d in array) {
                
                HNPlayModel *model = [HNPlayModel yy_modelWithDictionary:d];
                
                [self.historyDataSource addObject:model];
            }
            
            [self.tableView reloadData];
        }else{
            MBErrorMsg;
            [self.tableView reloadData];
        }

    } faild:^(NSError *error) {
        ERROR;
    }];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){return 1;}
    if (self.type == HNConsoleSystemModel) {
        return self.systemDataSource.count>10?10+1:self.systemDataSource.count+1;
    }else if (self.type == HNConsoleCustomModel){
        return self.customDataSource.count>10?10+1:self.customDataSource.count+1;
    }else{
        return self.historyDataSource.count>10?10+1:self.historyDataSource.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        HNConsoleTableHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HNConsoleTableHeadCell"];
        if (!cell) {
            cell = [[HNConsoleTableHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleTableHeadCell"];
            _weakself;
            cell.pressButtonBlock = ^(HNConsoleModelType type) {
                weakself.type = type;
                [weakself requestPlayList];
            };
        }
        return cell;
    }else if (indexPath.section == 1){

        HNSettingsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HNSettingsCell"];
        if (!cell) {
            cell = [[HNSettingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNSettingsCell"];
            cell.titleLabel.text = NSLocalizedString(@"更多模式", nil);
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"1d98f2"];
        }
        return cell;
      
    }else{

        HNConsoleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleListCell"];
        if (!cell) {
            cell = [[HNConsoleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleListCell"];

        }

        if (self.type == HNConsoleCustomModel) { //自定义
            HNPlayListModel *model = self.customDataSource[indexPath.row-1];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.nameLabel.text = model.name;
            cell.pressAddButtonBlock = ^{
                [self addToPlayList:model.modelId];
            };
        }else if (self.type == HNConsoleSystemModel){ //系统模式
            HNPlayListModel *model = self.systemDataSource[indexPath.row-1];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.nameLabel.text = model.name;
            cell.pressAddButtonBlock = ^{
                [self addToPlayList:model.modelId];
            };
        }else{ //历史模式
            HNPlayModel *model = self.historyDataSource[indexPath.row];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.nameLabel.text = model.name;
            cell.pressAddButtonBlock = ^{
                [self addToPlayList:model.m_id];
            };
        }

        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 1){ //最后一行
        if (self.type == HNConsoleHistroyModel) {
            
            HNConsoleHistroyViewController *vc = [HNConsoleHistroyViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (self.type == HNConsoleSystemModel){
            
            HNConsoleSystemViewController *vc = [HNConsoleSystemViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            HNConsoleCustomViewController *vc = [HNConsoleCustomViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Handle_height(128/2);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HNTableHedView *headView = [HNTableHedView new];
    headView.titleLabel.text = NSLocalizedString(@"情景模式库", nil);
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(44);
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.mas_equalTo(self.view);
        }
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Handle_height(98/2));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view).mas_offset(-49);
        }
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headView.mas_bottom);
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
        self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (HNConsoleMainHeadView *)headView{
    if (!_headView) {
        _headView = [HNConsoleMainHeadView new];
        [self.view addSubview:_headView];
        _weakself;
        _headView.pressRightButtonBlock = ^{
            HNPayListViewController *vc = [HNPayListViewController new];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headView;
}

- (NSMutableArray *)historyDataSource{
    if (!_historyDataSource) {
        _historyDataSource = [@[] mutableCopy];
    }
    return _historyDataSource;
}

- (NSMutableArray *)systemDataSource{
    if (!_systemDataSource) {
        _systemDataSource = [@[] mutableCopy];
    }
    return _systemDataSource;
}
- (NSMutableArray *)customDataSource{
    if (!_customDataSource) {
        _customDataSource = [@[] mutableCopy];
    }
    return _customDataSource;
}
@end

