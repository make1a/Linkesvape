//
//  HNGetDeviceInfoCode.h
//  Linkesvape
//
//  Created by make on 2018/1/9.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNGetDeviceInfoCode : NSObject
//命令格式：该命令共有9个有效字节，共分为一包传给设备

/**命令码*/
@property (nonatomic,copy)NSString * cmd;
/**
 数据总包数  pkg由大到小进行传输，如果是0表示最后一包。
 eg：共发送3包数据，pag分别是2、1、0；如果只有一包数据那么pkg就是0。
 */
@property (nonatomic,copy)NSString * pkg1;
/**数据总包数*/
@property (nonatomic,copy)NSString * pkg2;
/** 获取设备  1表示 主机设备; 2表示 从机设备.*/
@property (nonatomic,copy)NSString * deviceType;
/**设备MAC地址   MAC0 ~ MAC5. 6个字节*/
@property (nonatomic,copy)NSString * macAddress;

/**
 设备地址类型
 */
@property (nonatomic,copy)NSString * addressType;

/**获取设备信息命令字（ 0x01 ~ 0x08 ）*/
@property (nonatomic,copy)NSString * info;
/**CHECK SUM. 和*/
//@property (nonatomic,copy)NSString * checkSum;

@end



#pragma mark - HNDeviceInfoBackCode

@interface HNDeviceInfoBackCode : NSObject

/**命令码*/
@property (nonatomic,copy)NSString * cmd;
/**设备ID*/
@property (nonatomic,copy)NSString * deviceId;
/**设备软件版本信息低位*/
@property (nonatomic,copy)NSString * infoL;
/**设备软件版本信息高位*/
@property (nonatomic,copy)NSString * infoH;
/**Check SUM*/
@property (nonatomic,copy)NSString * checkSum;

@end







