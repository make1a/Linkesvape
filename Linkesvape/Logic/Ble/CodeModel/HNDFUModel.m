//
//  HNDFUModel.m
//  Linkesvape
//
//  Created by make on 2018/1/22.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNDFUModel.h"


@implementation HNDFUModel

+ (void)sendOTACode{
    
    HNDFUModel *model =[[HNDFUModel alloc]init];
    model.cmd = @"0E";
    model.pkg1 = @"00";
    model.pkg2 = @"00";
    model.O = @"4F";
    model.T = @"54";
    model.A = @"41";
    
    [HNBLEDataManager sendData:model];
    
}




@end
