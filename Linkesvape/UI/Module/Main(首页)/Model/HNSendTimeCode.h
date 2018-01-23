//
//  HNSendTimeCode.h
//  Linkesvape
//
//  Created by make on 2018/1/9.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNSendTimeCode : NSObject

@property (nonatomic,copy)NSString * cmd;
@property (nonatomic,copy)NSString * pkg1;
@property (nonatomic,copy)NSString * pkg2;
@property (nonatomic,copy)NSString * yearL;
@property (nonatomic,copy)NSString * yearH;
@property (nonatomic,copy)NSString * month;
@property (nonatomic,copy)NSString * day;
@property (nonatomic,copy)NSString * hour;
@property (nonatomic,copy)NSString * minute;


/**
 时间格式: 1 12小时制; 2 24小时制。
 */
@property (nonatomic,copy)NSString * timeFormate;

@property (nonatomic,copy)NSString * checkSum;

@end
