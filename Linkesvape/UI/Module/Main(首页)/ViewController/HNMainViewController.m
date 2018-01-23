//
//  HNMainViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainViewController.h"
#import "HNConnectDeviceViewController.h"
#import "HNNewsListViewController.h"
#import "HNConnectedDeviceListViewController.h"
#import "HNWebViewController.h"


//view
#import "HNMainContainerView.h"
#import "HNMainDeviceCell.h"
#import "HNMainTableHeadView.h"
#import "HNMainAddDeviceCell.h"
#import "HNMainNewsCell.h"
#import "HNMainQuestionCell.h"

//model
#import "HNBannerModel.h"
#import "HNDeviceConnectedModel.h"
#import "HNGetDeviceInfoCode.h"

@interface HNMainViewController ()<UITableViewDelegate,UITableViewDataSource,HNBleConnectDelegate>
@property (nonatomic,strong)HNMainContainerView * containerView;
@property (nonatomic,strong)NSMutableArray * bannerArray;
@property (nonatomic,strong)NSMutableArray * newsArray;
@property (nonatomic,strong)NSMutableArray * deviceListArray;
@end
@implementation HNMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getConnectedDeviceList];
    [HNBLEConnectManager shareInstance].delegate = self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationStyle];
    [self requestData];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HNAspectsStore getDeviceinfo:^(HNGetDeviceInfoCode *m) {
            DLog(@"拦截到的数据----macAddress:%@",m.macAddress);
        }];
    });
}

- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"首页", nil)];
    
    [self setRightButtonTitle:@"Test"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectOutTime:) name:kNotificationConnectDeviceOutTime object:nil];
}

- (void)onRightButtonClick:(id)sender{

    HNGetDeviceInfoCode *code = [HNGetDeviceInfoCode new];
    code.cmd = @"01";
    code.pkg1 = @"00";
    code.pkg2 = @"00";
    code.deviceType = @"01";
    code.macAddress = [HNBLEConnectManager shareInstance].currentDevice.macAddress;
    code.info = @"01";
    code.addressType = @"00";
    [HNBLEDataManager sendData:code];
    
}

#pragma  mark - Notify
- (void)connectOutTime:(NSNotification *)noti{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:NSLocalizedString(@"连接超时，检查蓝牙是否打开和设备是否在附近", nil)];
}
#pragma  mark - BLE delegate
- (void)connectDeviceSucceed:(CBPeripheral *)peripheral{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:NSLocalizedString(@"连接成功", nil)];
    [self.containerView.tableView reloadData];
}

- (void)disConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error{
    [self.containerView.tableView reloadData];
}

- (void)failToConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:error.localizedDescription];
}
#pragma  mark - 网络请求&数据处理
- (void)refreshEvent{
    //刷新banner
    NSMutableArray *imageURLStringsGroup = [@[] mutableCopy];
    for (HNBannerModel *model in self.bannerArray) {
        [imageURLStringsGroup addObject: model.src];
    }
    self.containerView.adScrollerView.imageURLStringsGroup = imageURLStringsGroup;
    
    [self.containerView.tableView reloadData];
}
- (void)requestData{
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:Index requestParameters:nil requestHeader:nil success:^(id responseObject) {
        
        NSArray *bannerArray = responseObject[@"d"][@"banner"];
        for (NSDictionary *dic in bannerArray) {
            HNBannerModel *bannerModel = [HNBannerModel yy_modelWithDictionary:dic];
            [self.bannerArray addObject:bannerModel];
        }
        
        NSArray *newsArray = responseObject[@"d"][@"news"];
        for (NSDictionary *dic in newsArray) {
            HNNewsModel *newsModel = [HNNewsModel yy_modelWithDictionary:dic];
            [self.newsArray addObject:newsModel];
        }
        
        [self refreshEvent];
        
        
    } faild:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        ERROR;
    }];
}

//获取设备列表
- (void)getConnectedDeviceList{
    self.deviceListArray = [[HNDeviceConnectedModel selectFromClassAllObject] mutableCopy];
    [self.containerView.tableView reloadData];
}

#pragma  mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.deviceListArray.count>5?5+1:self.deviceListArray.count+1;
            break;
        case 2:
            return 1;
        default:
            return self.newsArray.count>5?5:self.newsArray.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row == self.deviceListArray.count) { //最后一行
            HNMainAddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainAddDeviceCell"];
            if (!cell) {
                cell = [[HNMainAddDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainAddDeviceCell"];
                cell.pressAddBtnBlock = ^{
                    HNConnectDeviceViewController *vc = [[HNConnectDeviceViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                };
            }
            return cell;
            
        }else{ //设备
            HNDeviceConnectedModel *model = self.deviceListArray[indexPath.row];
            HNMainDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainDeviceCell"];
            if (!cell) {
                cell = [[HNMainDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainDeviceCell"];
                cell.pressConnectBlock = ^{
                    [MBProgressHUD showMessage:NSLocalizedString(@"正在连接", nil)];
                    [[HNBLEConnectManager shareInstance]cancelAllperipheral];
                    [[HNBLEConnectManager shareInstance]connectDeviceWithMacAddress:model.macAddress];
                };
            }
            if ([model.macAddress isEqualToString:[HNBLEConnectManager shareInstance].currentDevice.macAddress]) { //当前连接设备
                [cell setCurrentStatusWithStyle:HNMainDeviceCellConnectOnline]; //在线
            }else{
                [cell setCurrentStatusWithStyle:HNMainDeviceCellConnectOffLine];
            }
            cell.nameLabel.text = model.name;
            return cell;
        }
        
    }else if (indexPath.section == 1){ //新闻
        
        HNMainNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainNewsCell"];
        if (!cell) {
            cell = [[HNMainNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainNewsCell"];
        }
        
        HNNewsModel *model = self.newsArray[indexPath.row];
        [cell cellRefreshWithModel:model];
        return cell;
        
    }else{  //常见问题
        HNMainQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainQuestionCell"];
        if (!cell) {
            cell = [[HNMainQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainQuestionCell"];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //语言
    NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];
    if (indexPath.section == 0) {
        if (indexPath.row == self.deviceListArray.count) {
            HNConnectDeviceViewController *vc = [[HNConnectDeviceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            HNDeviceConnectedModel *model = self.deviceListArray[indexPath.row];
            if ([model.macAddress isEqualToString:[HNBLEConnectManager shareInstance].currentDevice.macAddress]) { //当前连接设备
                [self.tabBarController setSelectedIndex:1];
            }
            
        }
    }else if (indexPath.section == 1){
        
        HNNewsModel *model = self.newsArray[indexPath.row];
        HNWebViewController *vc = [HNWebViewController new];
        vc.urlString = [NSString stringWithFormat:@"http://118.126.111.250/h5/index/newsDetail?Accept-Language=%@&id=%@",language,model.newsId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2){
        
        HNWebViewController *vc = [HNWebViewController new];
        NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];

        vc.urlString = [NSString stringWithFormat:@"http://118.126.111.250/h5/index/questions?Accept-Language=%@",language];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <2) {
        HNMainTableHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"HNMainTableHeadView" owner:nil options:nil].firstObject;
        headView.backgroundColor = [UIColor whiteColor];
        
        headView.pressRightButtonBlock = ^{
            if (section == 1) {
                HNNewsListViewController *vc = [HNNewsListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (section == 0){
                HNConnectedDeviceListViewController *vc = [HNConnectedDeviceListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        if (section == 0) {
            headView.textLabel.text = NSLocalizedString(@"我的设备", nil);
        }else{
            headView.textLabel.text = NSLocalizedString(@"最新资讯", nil);
        }
        return headView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<2) {
        return Handle_width(45);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Handle_height(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {return Handle_height(40);}
        return Handle_height(60);
    }else if (indexPath.section == 1){
        return Handle_height(75);
    }else{
        return Handle_height(50);
    }
}

#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        }else {
            make.left.right.top.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).mas_offset(-49);
        }
    }];
}

#pragma  mark - 懒加载
- (HNMainContainerView *)containerView{
    if (!_containerView) {
        _containerView = [[HNMainContainerView alloc]init];
        [self.view addSubview:_containerView];
        _containerView.tableView.delegate = self;
        _containerView.tableView.dataSource = self;
        _containerView.adScrollerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"ckick %ld",currentIndex);
        };
    }
    return _containerView;
}
- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [@[] mutableCopy];
    }
    return _bannerArray;
}
- (NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [@[] mutableCopy];
    }
    return _newsArray;
}
- (NSMutableArray *)deviceListArray{
    if (!_deviceListArray) {
        _deviceListArray = [@[] mutableCopy];
    }
    return _deviceListArray;
}

#pragma  mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
