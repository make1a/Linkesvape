//
//  HNBleDeviceModel.m
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNBleDeviceModel.h"

@implementation HNBleDeviceModel

//假数据
- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        NSData *factoryCode = [data subdataWithRange:NSMakeRange(0, 2)];
        NSData *macAddress = [data subdataWithRange:NSMakeRange(2, 6)];
        NSData *addressType = [data subdataWithRange:NSMakeRange(8, 1)];
        
        self.manufacturerId = [NSString convertDataToHexStr:factoryCode];
        self.macAddress = [NSString convertDataToHexStr:macAddress];
        self.addressType =[NSString convertDataToHexStr:addressType];
    }
    return self;
}



@end
