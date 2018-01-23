//
//  HNDeviceConnectedModel.h
//  Linkesvape
//
//  Created by make on 2018/1/8.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNDeviceConnectedModel : FFDataBaseModel

//localName
@property (nonatomic,copy)NSString * name;

//mac地址
@property (nonatomic,copy)NSString * macAddress;

@property (nonatomic,copy)NSString * addressType;

//厂商ID
@property (nonatomic,copy)NSString * manufacturerId;

- (instancetype)initWithBleModel:(HNBleDeviceModel *)model;
@end



/**
 HNScanDeviceModel  扫描得到的设备（未连接设备），改名字的表。
 不能跟连接过的历史设备共用一张，但是在连接后名字也要存到历史设备里。
 */

@interface HNScanDeviceModel:FFDataBaseModel

//localName
@property (nonatomic,copy)NSString * name;

//mac地址
@property (nonatomic,copy)NSString * macAddress;

@property (nonatomic,copy)NSString * addressType;

//厂商ID
@property (nonatomic,copy)NSString * manufacturerId;

- (instancetype)initWithBleModel:(HNBleDeviceModel *)model;

+ (void)alertNameWithModel:(HNBleDeviceModel *)model andNewName:(NSString *)name;
@end
