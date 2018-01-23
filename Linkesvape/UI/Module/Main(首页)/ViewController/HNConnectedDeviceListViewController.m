//
//  HNConnectedDeviceListViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/8.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConnectedDeviceListViewController.h"
#import "HNMainDeviceCell.h"
#import "HNDeviceConnectedModel.h"

@interface HNConnectedDeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * deviceListArray;
@end

@implementation HNConnectedDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationStyle];
    [self getDevicesFromDB];
    
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"设备列表", nil)];
}

#pragma  mark - 数据
- (void)getDevicesFromDB{
    self.deviceListArray = [[HNDeviceConnectedModel selectFromClassAllObject] mutableCopy];
    [self.tableView reloadData];
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HNDeviceConnectedModel *model = self.deviceListArray[indexPath.row];
    HNMainDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNMainDeviceCell"];
    if (!cell) {
        cell = [[HNMainDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNMainDeviceCell"];
        cell.pressConnectBlock = ^{
            [[HNBLEConnectManager shareInstance]cancelAllperipheral];
//            [[HNBLEConnectManager shareInstance]connectDevice:model.peripheral];
        };
    }
    if ([model.macAddress isEqualToString:[HNBLEConnectManager shareInstance].currentDevice.macAddress]) { //当前连接设备
        [cell setCurrentStatusWithStyle:HNMainDeviceCellConnectOnline]; //在线
    }else{
        [cell setCurrentStatusWithStyle:HNMainDeviceCellConnectOffLine];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(75);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Handle_height(10);
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
    }
    return _tableView;
}
- (NSMutableArray *)deviceListArray{
    if (!_deviceListArray) {
        _deviceListArray = [@[] mutableCopy];
    }
    return _deviceListArray;
}
@end
