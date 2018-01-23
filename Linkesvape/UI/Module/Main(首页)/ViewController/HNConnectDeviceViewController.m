//
//  HNConnectDeviceViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNConnectDeviceViewController.h"
#import "HNDeviceSearchResultViewController.h"
//views
#import "HNNoticeInfoView.h"
#import "HNConnectDeviceSucCell.h"
#import "HNConnectPreDeviceCell.h"
#import "HNMainTableHeadView.h"
#import "HNNoticeInputView.h"

//Model
#import "HNDeviceConnectedModel.h"


@interface HNConnectDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,HNBleConnectDelegate>
@property (nonatomic,strong)UISearchController * searchController;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)HNNoticeInputView *noticeView;
@property (nonatomic,strong)HNNoticeInfoView *connectNoticeView;
@property (nonatomic,strong)NSMutableArray * deviceListArray;
@property (nonatomic,strong)NSMutableArray * connectListArray;
@end

@implementation HNConnectDeviceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HNBLEConnectManager shareInstance].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationStyle];
    [self masLayoutSubViews];
    
    [self refreshEvent];
//    self.navigationBar.translucent = NO;
    
}

- (void)setNavgationStyle{
    [self setNavigationTitle:NSLocalizedString(@"设备连接", nil)];
}

- (void)refreshEvent{
//    //第一次需要同步单例里面的数据源,因为APP启动开始就已经在扫描了

    [[HNBLEConnectManager shareInstance]scan];
    if ([HNBLEConnectManager shareInstance].currentDevice) {
        [self.connectListArray addObject:[HNBLEConnectManager shareInstance].currentDevice];
    }
    [self.tableView reloadData];
}
#pragma  mark - 蓝牙连接

- (void)foundNewDevice:(CBPeripheral *)peripheral central:(CBCentralManager *)central advertisementData:(NSDictionary *)advertisementData{
    self.deviceListArray = [[HNBLEConnectManager shareInstance].deviceList mutableCopy];
    [self.tableView reloadData];
}
- (void)connectDeviceSucceed:(CBPeripheral *)peripheral{
    
    [MBProgressHUD showSuccess:NSLocalizedString(@"连接成功", nil)];
    [self.deviceListArray removeObject:[HNBLEConnectManager shareInstance].currentDevice];
    [self.connectListArray addObject:[HNBLEConnectManager shareInstance].currentDevice];
    [self.tableView reloadData];
    
    //存储到数据库
    NSArray *devices = [HNDeviceConnectedModel selectFromClassPredicateWithFormat:[NSString stringWithFormat:@"where  macAddress = '%@'",[HNBLEConnectManager shareInstance].currentDevice.macAddress]];
    if (devices.count == 0) {
        HNDeviceConnectedModel *device = [[HNDeviceConnectedModel alloc]initWithBleModel:[HNBLEConnectManager shareInstance].currentDevice];
        [device insertObject];
    }else{
        HNDeviceConnectedModel *device = devices.firstObject;
        [device updateObject];
    }
    
}
- (void)disConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error{
    [self.connectListArray removeAllObjects];
    [self refreshEvent];
}

#pragma  mark - searchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [searchController.searchBar  text];
    HNDeviceSearchResultViewController *vc = (HNDeviceSearchResultViewController *)searchController.searchResultsController;
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    [vc.dataSource removeAllObjects];
    for (HNBleDeviceModel *model in self.deviceListArray) {
        if ([model.name containsString:searchString]) {
            [vc.dataSource addObject:model];
        }
    }
    for (HNBleDeviceModel *model in self.connectListArray) {
        if ([model.name containsString:searchString]) {
            [vc.dataSource addObject:model];
        }
    }
    [vc.tableView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    if (@available(iOS 11.0, *)) {
        
    }else{
        [self setStatusBarBackgroundColor:[UIColor clearColor]];
        _searchController.searchBar.backgroundImage = [UIImage new];
    }
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    if (@available(iOS 11.0, *)) {
        
    }else{
        
        [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"2A2B2C"]];
        _searchController.searchBar.backgroundImage = nil;
    }
}



#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.connectListArray.count;
    }
    return self.deviceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _weakself;
    
    if (indexPath.section == 0) { //已连接设备
       HNBleDeviceModel *model =  self.connectListArray[indexPath.row];
        HNConnectDeviceSucCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConnectDeviceSucCell"];
        if (!cell) {
            cell = [[HNConnectDeviceSucCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConnectDeviceSucCell"];
            
            cell.pressEditorButton = ^{
                [self.view addSubview:self.noticeView];
                [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(self.view);
                    make.top.mas_equalTo(self.tableView).mas_offset(.1);
                }];
            };
            self.noticeView.pressSumbitButtonBlock = ^{ //修改名称
                [HNScanDeviceModel alertNameWithModel:model andNewName:weakself.noticeView.textfield.text];
                //更新已连接的历史数据库
                [weakself.tableView reloadData];
            };
        }
        [cell cellRefreshWithAlertName:model];
        return cell;
        
    }else{ //未连接设备
        
        
        HNBleDeviceModel *model =  self.deviceListArray[indexPath.row];
        HNConnectPreDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConnectPreDeviceCell"];
        if (!cell) {
            cell = [[HNConnectPreDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConnectPreDeviceCell"];
            cell.pressEditorButton = ^{
                [[UIApplication sharedApplication].keyWindow  addSubview:self.noticeView];
                [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(self.view);
                    make.top.mas_equalTo(self.tableView).mas_offset(.1);
                }];
            };
            self.noticeView.pressSumbitButtonBlock = ^{ //修改名称
                [HNScanDeviceModel alertNameWithModel:model andNewName:weakself.noticeView.textfield.text];
                [weakself.tableView reloadData];
            };
        }
        
        [cell cellRefreshWithAlertName:model];
        return cell;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        HNBleDeviceModel *model = self.deviceListArray[indexPath.row];
        [self.view addSubview:self.connectNoticeView];
        self.connectNoticeView.detailLabel.text = model.name;
        [self.connectNoticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.tableView).mas_offset(.1);
        }];
        //连接设备
        self.connectNoticeView.pressRightButton = ^{
            [[HNBLEConnectManager shareInstance]cancelAllperipheral];
            [[HNBLEConnectManager shareInstance]connectDevice:model.peripheral];
        };
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HNMainTableHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"HNMainTableHeadView" owner:nil options:nil].firstObject;
    headView.arrowButton.hidden = YES;
    if (section == 0){
        headView.textLabel.text = NSLocalizedString(@"已连接设备", nil);
    }else{
        headView.textLabel.text = NSLocalizedString(@"选取设备...", nil);
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Handle_height(54);
    }
    return Handle_height(62);
}

#pragma  mark - 布局
- (void)masLayoutSubViews{
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
        if (@available(iOS 11.0, *)) {
            self.navigationItem.searchController = self.searchController;
            self.navigationItem.hidesSearchBarWhenScrolling = NO;
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        }else{
            _tableView.tableHeaderView = self.searchController.searchBar;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        self.definesPresentationContext = YES;
        HNDeviceSearchResultViewController *vc = [HNDeviceSearchResultViewController new];
        _searchController = [[UISearchController alloc]initWithSearchResultsController:vc];
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.backgroundImage = [UIImage new];
        _searchController.searchBar.placeholder = NSLocalizedString(@"输入设备名称、设备号查询", nil);
        UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
//        searchField.textColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = [UIColor colorWithHexString:@"2A2B2C"];
        [_searchController.searchBar sizeToFit];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return _searchController;
}

- (HNNoticeInputView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[HNNoticeInputView alloc]init];
        _noticeView.titleLabel.text = NSLocalizedString(@"修改设备名称", nil);
        _noticeView.textfield.text = @"";

    }
    return _noticeView;
}
- (HNNoticeInfoView *)connectNoticeView{
    if (!_connectNoticeView) {
        _connectNoticeView = [[HNNoticeInfoView alloc]init];
    }
    return _connectNoticeView;
}
- (NSMutableArray *)deviceListArray{
    if (!_deviceListArray) {
        _deviceListArray = [@[] mutableCopy];
    }
    return _deviceListArray;
}
- (NSMutableArray *)connectListArray{
    if (!_connectListArray) {
        _connectListArray = [@[] mutableCopy];
    }
    return _connectListArray;
}

@end
