//
//  HNBLEConnectManager.h
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNBleDeviceModel.h"

//过滤名称
extern NSString *const filterConditionName;

//服务UUID
extern NSString *const kDeviceServiceUUID;
extern NSString *const kDeviceCharacteristicsWrite;
extern NSString *const kDeviceCharacteristicsRead;
extern NSString *const kDeviceCharacteristicsNotify;

//蓝牙状态
extern NSString *const kNotificationBleStatePoweredOn;
extern NSString *const kNotificationBleStatePoweredOff;

//连接超时
extern NSString *const kNotificationConnectDeviceOutTime;

@protocol HNBleConnectDelegate<NSObject>

@optional
/**
 发现新设备的回调
 */
- (void)foundNewDevice:(CBPeripheral *)peripheral central:(CBCentralManager *)central advertisementData:(NSDictionary *)advertisementData;

/**
 外设连接成功
 */
- (void)connectDeviceSucceed:(CBPeripheral *)peripheral;

/**
 外设断开连接
 */
- (void)disConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error;

- (void)failToConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error;
@end;



@interface HNBLEConnectManager : NSObject

@property (nonatomic,strong)BabyBluetooth * baby;
@property (nonatomic,strong,readonly)NSMutableArray * deviceList;
@property (nonatomic,strong,readonly)HNBleDeviceModel * currentDevice;
@property (nonatomic,weak)id <HNBleConnectDelegate> delegate;


//************************项目定制属性******************************

/**
 固件版本
 */
@property (nonatomic,copy,readonly)NSString *softVersion;



+ (HNBLEConnectManager *)shareInstance;

#pragma mark - 连接操作
- (void)scan;
- (void)stopScan;
- (void)connectDevice:(CBPeripheral *)peripheral;
- (void)cancelPeripheral:(CBPeripheral *)peripheral;
- (void)cancelAllperipheral;


- (void)connectWithOTA;
/**
 根据mac地址搜索周围广播连接设备

 @param mac macAddress
 @param outTime 超时时间
 */
- (void)connectDeviceWithMacAddress:(NSString *)mac andOutTimer:(NSInteger)outTime;
#pragma mark - 数据读写
- (void)writeValueToDevice:(NSData *)data;
@end
