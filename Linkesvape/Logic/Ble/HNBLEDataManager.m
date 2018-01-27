//
//  HNBLEDataManager.m
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNBLEDataManager.h"
#import <objc/runtime.h>
#import "NSObject+AnalysisDataToModel.h"
#import "HNGetDeviceInfoCode.h"

@implementation HNBLEDataManager

#pragma  mark - 数据接收
+ (void)receiveData:(NSData *)data{
    
    NSString *dataString =  [NSString convertDataToHexStr:[data subdataWithRange:NSMakeRange(0, 1)]];
   
   int backCode = [[NSString hexStringToDecima:dataString] intValue];

    switch (backCode) {
        case 0x1:
        {
            
        }
            break;
        case 0x2:
        {
            
        }
        case 0x0F: //芯片升级
        {
            [self getDeviceUpdataStatus:data];
        }
        default:
            break;
    }

    [self getDeviceInfoModel:data];
    
}

#pragma  mark - 被拦截的action
+ (HNGetDeviceInfoCode *)getDeviceInfoModel:(NSData *)data{
   HNGetDeviceInfoCode *code = [HNGetDeviceInfoCode AnalysisDataToModel:data BytesArray:@[@1,@1,@1,@1,@6,@1,@1]];
    DLog(@"%@",code);
    return code;
}

//主控芯片升级返回状态
+(BOOL)getDeviceUpdataStatus:(NSData *)data{
    if (data) {
        return YES;
    }
    return NO;
}





#pragma  mark - 发送数据
+ (void)sendData:(id)model{
    
    unsigned int methodCount = 0;
    NSMutableString *code = [@"" mutableCopy];
    int totalNumber = 0;
    
    
    Ivar * ivars = class_copyIvarList([model class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];

        NSString *str = object_getIvar(model, ivar);
        
        //补0
        if (str.length%2 !=0) {
            str  = [NSString padingZero:str length:str.length+1];
        }

        /********************计算checkCode*************************/
        for (int j = 0; j<str.length; j+=2) {
            //转10进制
            int sum = [[NSString hexStringToDecima:[str substringWithRange:NSMakeRange(j, 2)]] intValue];

            totalNumber += sum;
//            DLog(@"sum ==%d  totalNumber =%d",sum,totalNumber);
        }
        /*********************************************/
        
        
        if (!str) {
            DLog(@"****************错误:还有属性没有赋值******************");
            return;
        }
        [code appendString:str];
    }
    
    //转16进制
    NSString * c = [NSString getHexByDecimal:totalNumber];
    
  /*********************************************/
    if (c.length>=2) {
        // 拼接checkCode
        [code appendString:[c substringWithRange:NSMakeRange(c.length-2, 2)]];
    }
  /*********************************************/
    
    NSData *data = [NSString convertHexStrToData:code];
    
    [[HNBLEConnectManager shareInstance]writeValueToDevice:data];
    DLog(@"发送的数据:%@",data);
    free(ivars);
    
}
@end
