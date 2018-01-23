//
//  HNBleDeviceModel.h
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNBleDeviceModel : NSObject

@property (nonatomic,strong)CBPeripheral * peripheral;
//localName
@property (nonatomic,copy)NSString * name;

//mac地址
@property (nonatomic,copy)NSString * macAddress;

@property (nonatomic,copy)NSString * addressType;

//厂商ID
@property (nonatomic,copy)NSString * manufacturerId;


- (instancetype)initWithData:(NSData *)data;
@end
