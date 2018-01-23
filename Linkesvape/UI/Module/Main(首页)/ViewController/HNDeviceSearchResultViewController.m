//
//  HNDeviceSearchResultViewController.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNDeviceSearchResultViewController.h"
#import "HNConnectPreDeviceCell.h"
#import "HNNoticeInputView.h"
#import "HNNoticeInfoView.h"
#import "HNConnectDeviceSucCell.h"
#import "HNDeviceConnectedModel.h"
@interface HNDeviceSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)HNNoticeInputView *noticeView;
@property (nonatomic,strong)HNNoticeInfoView *connectNoticeView;
@end

@implementation HNDeviceSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _weakself;
    HNBleDeviceModel *model = self.dataSource[indexPath.row];
    if ([model.macAddress isEqualToString:[HNBLEConnectManager shareInstance].currentDevice.macAddress]) { //已连接
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
    }else{
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
    HNBleDeviceModel *model = self.dataSource[indexPath.row];
    if (![model.macAddress isEqualToString:[HNBLEConnectManager shareInstance].currentDevice.macAddress]) { //已连接
        HNBleDeviceModel *model = self.dataSource[indexPath.row];
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

- (HNNoticeInputView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[HNNoticeInputView alloc]init];
        _noticeView.titleLabel.text = NSLocalizedString(@"修改设备名称", nil);
        _noticeView.textfield.text = @"";
    }
    return _noticeView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}
- (HNNoticeInfoView *)connectNoticeView{
    if (!_connectNoticeView) {
        _connectNoticeView = [[HNNoticeInfoView alloc]init];
    }
    return _connectNoticeView;
}
@end
