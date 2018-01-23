
//
//  HNDeviceConnectedModel.m
//  Linkesvape
//
//  Created by make on 2018/1/8.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNDeviceConnectedModel.h"

@implementation HNDeviceConnectedModel
- (instancetype)initWithBleModel:(HNBleDeviceModel *)model
{
    self = [super init];
    if (self) {
        self.name = model.name;
        self.macAddress = model.macAddress;
        self.addressType = model.addressType;
        self.manufacturerId = model.manufacturerId;
    }
    return self;
}
@end



@implementation HNScanDeviceModel
- (instancetype)initWithBleModel:(HNBleDeviceModel *)model
{
    self = [super init];
    if (self) {
        self.name = model.name;
        self.macAddress = model.macAddress;
        self.addressType = model.addressType;
        self.manufacturerId = model.manufacturerId;
    }
    return self;
}

+ (void)alertNameWithModel:(HNBleDeviceModel *)model andNewName:(NSString *)name{
    if (name.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入设备名称", nil)];
        return;
    }
    HNScanDeviceModel *scanModel = [HNScanDeviceModel selectFromClassPredicateWithFormat:[NSString stringWithFormat:@"where macAddress = '%@'",model.macAddress]].firstObject;
    if (!scanModel) {
        scanModel = [[HNScanDeviceModel alloc]initWithBleModel:model];
        scanModel.name = name;
        [scanModel insertObject];
    }else{
        scanModel.name = name;
        [scanModel updateObject];
    }
    
    //更新连接历史的数据库
    
    HNDeviceConnectedModel *connectedModel = [HNDeviceConnectedModel selectFromClassPredicateWithFormat:[NSString stringWithFormat:@"where macAddress = '%@'",model.macAddress]].firstObject;
    if (connectedModel) {
        connectedModel.name = name;
        [connectedModel updateObject];
    }
    
    
}
@end
