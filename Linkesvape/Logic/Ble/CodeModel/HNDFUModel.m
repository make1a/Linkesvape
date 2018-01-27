//
//  HNDFUModel.m
//  Linkesvape
//
//  Created by make on 2018/1/22.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNDFUModel.h"


@implementation HNDFUModel

+ (NSString *)sendOTACode{
    
    HNDFUModel *model =[[HNDFUModel alloc]init];
    model.cmd = @"0E";
    model.pkg1 = @"00";
    model.pkg2 = @"00";
    model.O = @"4F";
    model.T = @"54";
    model.A = @"41";
    
    
    NSString *mac = [HNBLEConnectManager shareInstance].currentDevice.macAddress;
//    NSString *mac = @"1A2B3C4D5E";
    [HNBLEDataManager sendData:model];
//
//    NSMutableString *macN = [@"" mutableCopy];
//    for (int i = 0; i<mac.length; i+=2) {
//        if (i < mac.length - 2) {
//            [macN appendString: [mac substringWithRange:NSMakeRange(i, 2)]];
//        }else{
//            NSInteger decima = [[NSString hexStringToDecima:[mac substringWithRange:NSMakeRange(i, 2)]] integerValue];
//            decima+=1;
//            [macN appendString:[NSString getHexByDecimal:decima]];
//        }
//    }
//
    [[HNBLEConnectManager shareInstance]stopScan];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([HNBLEConnectManager shareInstance].currentDevice) {
            [[HNBLEConnectManager shareInstance]cancelPeripheral:[HNBLEConnectManager shareInstance].currentDevice.peripheral];
        }
    });
    return mac;
}




@end
