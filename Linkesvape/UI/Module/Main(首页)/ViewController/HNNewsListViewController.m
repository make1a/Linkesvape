//
//  HNNewsListViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNNewsListViewController.h"
#import "HNWebViewController.h"

#import "HNMainNewsCell.h"

//model
#import "HNBannerModel.h"

@interface HNNewsListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * newsArray;
@end

@implementation HNNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];

    [self requestData:1];
    
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"新闻资讯", nil)];
}
#pragma  mark - 数据请求
- (void)requestData:(NSInteger)page{
    NSDictionary *dic = @{@"page" : @(page)};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:News requestParameters:dic requestHeader:nil success:^(id responseObject) {
        [self.newsArray removeAllObjects];
        NSArray *newsArray = responseObject[@"d"][@"news"][@"items"];
        for (NSDictionary *dic in newsArray) {
            HNNewsModel *newsModel = [HNNewsModel yy_modelWithDictionary:dic];
            [self.newsArray addObject:newsModel];
        }
        
        if (self.newsArray.count < [responseObject[@"d"][@"news"][@"total"] integerValue])
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
    } faild:^(NSError *error) {
        ERROR;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - MJRefresh

- (void)headerRefreshing
{
    _page = 1;
    [self requestData:_page];
}

- (void)footerRefreshing
{
    _page ++;
    [self requestData:_page];
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HNMainNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainNewsCell"];
    if (!cell) {
        cell = [[HNMainNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainNewsCell"];
    }
    HNNewsModel *model = self.newsArray[indexPath.row];
    [cell cellRefreshWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HNNewsModel *model = self.newsArray[indexPath.row];
    HNWebViewController *vc = [HNWebViewController new];
    NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];

    vc.urlString = [NSString stringWithFormat:@"http://118.126.111.250/h5/index/newsDetail?Accept-Language=%@&id=%@",language,model.newsId];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(75);
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
- (NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [@[] mutableCopy];
    }
    return _newsArray;
}
@end
