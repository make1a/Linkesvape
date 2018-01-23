//
//  NSObject+AnalysisDataToModel.m
//  Linkesvape
//
//  Created by make on 2018/1/19.
//  Copyright © 2018年 make. All rights reserved.
//

#import "NSObject+AnalysisDataToModel.h"
#import <objc/runtime.h>
@implementation NSObject (AnalysisDataToModel)
+(id)AnalysisDataToModel:(NSData *)data BytesArray:(NSArray *)array{
    
    if (array.count==0) {
        return nil;
    }
    
    id model  = [[self alloc]init];
    
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);

    if (outCount != array.count) {
        DLog(@"~~~~~~~~~传入的数据有误~~~~~~~~~`");
        return nil;
    }
    if (data.length < outCount) {
        DLog(@"*************接收到的数据有误******************");
        return nil;
    }
    for (int i = 0; i<outCount; i++) {
        
        int length = [array[i] intValue];
        int lastLength = 0;
        Ivar ivar = ivars[i];
        NSString *str;
        
        for (int j = 0; j<i; j++) {
            lastLength += [array[j] intValue];
        }
         str = [NSString convertDataToHexStr:[data subdataWithRange:NSMakeRange(lastLength, length)]];

        object_setIvar(model, ivar, str);

    }
    return model;
}
@end
