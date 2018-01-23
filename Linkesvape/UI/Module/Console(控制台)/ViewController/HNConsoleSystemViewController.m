//
//  HNConsoleSystemViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleSystemViewController.h"
#import "HNPlayListResultViewController.h"
#import "HNConsoleHistoryListCell.h"
#import "HNPlayListModel.h"
#import "UIImage+TinColor.h"

@interface HNConsoleSystemViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
{
    NSInteger _page;
}
@property (nonatomic,strong)UISearchController * searchController;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * systemDataSource;
@end

@implementation HNConsoleSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestPlayList:1];

    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    }
    self.definesPresentationContext = YES;
}

- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"系统模式", nil)];
    [self setRightButtonImage:[UIImage imageNamed:@"search"]];
}

- (void)configUI{
    
}
#pragma  mark- 数据
- (void)requestPlayList:(NSInteger)page{
    
    NSString *type = @"system";
    
    NSDictionary *dic = @{@"type":type,@"page":@(page)};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:ModelList requestParameters:dic requestHeader:nil success:^(id responseObject) {
        
        DLog(@"responseObject==%@",responseObject);
        
        [self.systemDataSource removeAllObjects];
        
        NSArray *array = responseObject[@"d"][@"list"][@"items"];
        
        for (NSDictionary *d in array) {
            
            HNPlayListModel *model = [HNPlayListModel yy_modelWithDictionary:d];
            
            [self.systemDataSource addObject:model];
            
        }
        if (self.systemDataSource.count < [responseObject[@"d"][@"list"][@"total"] integerValue])
        {
            self.tableView.mj_footer.hidden = NO;
        }
        else
        {
            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
    } faild:^(NSError *error) {
        DLog(@"%@",error.localizedDescription);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)headerRefreshing
{
    _page = 1;
    [self requestPlayList:_page];
}

- (void)footerRefreshing
{
    _page ++;
    [self requestPlayList:_page];
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

#pragma  mark - 点击
- (void)onRightButtonClick:(id)sender{
    
    if (@available(iOS 11.0, *)) {
    }else{
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField becomeFirstResponder];
}

#pragma  mark - searchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [searchController.searchBar  text];
    HNPlayListResultViewController *vc = (HNPlayListResultViewController *)searchController.searchResultsController;
    vc.edgesForExtendedLayout = UIRectEdgeNone;

    NSDictionary *dic = @{@"type":@"system",@"search":searchString};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:ModelList requestParameters:dic requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            NSArray *array = responseObject[@"d"][@"list"][@"items"];
            [vc.dataSource removeAllObjects];
            for (NSDictionary *d in array) {
                HNPlayListModel *model = [HNPlayListModel yy_modelWithDictionary:d];
                [vc.dataSource addObject:model];
            }
        
            [vc.tableView reloadData];
        }
    } faild:^(NSError *error) {
        ERROR;
    }];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    if (@available(iOS 11.0, *)) {
        
    }else{
        [self setStatusBarBackgroundColor:[UIColor clearColor]];
        self.tableView.tableHeaderView = nil;
    }
}
- (void)willPresentSearchController:(UISearchController *)searchController{
    if (@available(iOS 11.0, *)) {
        
    }else{
        
        [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"2A2B2C"]];
    }
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.systemDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNPlayListModel *model = self.systemDataSource[indexPath.row];
    HNConsoleHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleHistoryListCell"];
    if (!cell) {
        cell = [[HNConsoleHistoryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleHistoryListCell"];
    }
    cell.pressRightBtnBlock = ^{
        [self addToPlayList:model.modelId];
    };
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Handle_height(10);
}

#pragma  mark - 布局
- (void)masLayoutSubview{

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
//        } else {
            make.edges.equalTo(self.view);
//        }
    }];
}
#pragma  mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.view addSubview:_tableView];
        _weakself;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself headerRefreshing];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakself footerRefreshing];
        }];
    
    }
    return _tableView;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:[HNPlayListResultViewController new]];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.barTintColor = [UIColor colorWithHexString:@"2A2B2C"];
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.placeholder = NSLocalizedString(@"输入设备名称、设备号查询", nil);
        UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        searchField.backgroundColor = [UIColor grayColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return _searchController;
}

- (NSMutableArray *)systemDataSource{
    if (!_systemDataSource) {
        _systemDataSource = [@[] mutableCopy];
    }
    return _systemDataSource;
}
@end


