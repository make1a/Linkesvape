//
//  HNEspectStore.h
//  Linkesvape
//
//  Created by make on 2018/1/19.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNGetDeviceInfoCode.h"

@interface HNAspectsStore : NSObject

+ (void)getDeviceinfo:(void(^)(HNGetDeviceInfoCode *m))handler_block;
//获取蓝牙芯片升级回复状态
+(void)getDeviceUpdateStatus:(void (^)(BOOL isSuccess))handlerBlock;
@end
