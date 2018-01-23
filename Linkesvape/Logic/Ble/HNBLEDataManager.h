//
//  HNBLEDataManager.h
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNGetDeviceInfoCode.h"

@interface HNBLEDataManager : NSObject



#pragma mark - 数据接收
+ (void)receiveData:(NSData *)data;



#pragma mark - 数据解析

+ (HNGetDeviceInfoCode *)getDeviceInfoModel:(NSData *)data;


#pragma mark - 数据发送
/**
 发送数据

 @param model 实例化model

 */
+ (void)sendData:(id)model;
@end
