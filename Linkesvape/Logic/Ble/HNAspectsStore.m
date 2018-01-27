//
//  HNEspectStore.m
//  Linkesvape
//
//  Created by make on 2018/1/19.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNAspectsStore.h"
#import "Aspects.h"
#import "HNBLEDataManager.h"

@implementation HNAspectsStore

+ (void)getDeviceinfo:(void(^)(HNGetDeviceInfoCode *m))handler_block
{
    
    [object_getClass([HNBLEDataManager class]) aspect_hookSelector:@selector(getDeviceInfoModel:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,NSData *data) {
        __unsafe_unretained HNGetDeviceInfoCode *model;
        [aspectInfo.originalInvocation getReturnValue:&model];
        if (handler_block) {
            handler_block(model); 
        }
    } error:NULL];
}

+(void)getDeviceUpdateStatus:(void (^)(BOOL isSuccess))handlerBlock{
    
    [object_getClass([HNBLEDataManager class]) aspect_hookSelector:@selector(getDeviceUpdataStatus:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,NSData *data){
        BOOL isSuccess;
        [aspectInfo.originalInvocation getReturnValue:&isSuccess];
        if (handlerBlock) {
            handlerBlock(isSuccess);
        }
    } error:NULL];
}
@end
