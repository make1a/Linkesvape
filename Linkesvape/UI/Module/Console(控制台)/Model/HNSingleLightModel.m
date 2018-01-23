//
//  HNSingleLightModel.m
//  Linkesvape
//
//  Created by make on 2018/1/11.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSingleLightModel.h"

@implementation HNCustomInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i<6; i++) {
            HNSingleLightModel *model = [[HNSingleLightModel alloc]init];
            [self.lamps addObject:model];
        }
    }
    return self;
}



- (NSMutableArray *)lamps{
    if (!_lamps) {
        _lamps = [@[] mutableCopy];
    }
    return _lamps;
}
@end




@implementation HNSingleLightModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i<16; i++) {
            HNLightInfoModel *model = [[HNLightInfoModel alloc]init];
            model.color = @"";
            model.hz = @"";
            [self.infos addObject:model];
        }
    }
    return self;
}

- (NSMutableArray *)infos{
    if (!_infos) {
        _infos = [@[] mutableCopy];
    }
    return _infos;
}

@end




@interface HNLightInfoModel ()

//@property (nonatomic,strong)NSArray * colorArray;

@end

@implementation HNLightInfoModel

-(NSString *)ColorStringWithindex:(NSInteger)index{
    NSArray *colorArray = @[@"FA0300",@"03FF07",@"08DDDB",@"FE6603",@"0057DD",@"FFFFFF",@"FF31AA",@"0"];
    if (colorArray.count > index) {
        return colorArray[index];
    }else{
        DLog(@"****************ERRERO  数组越界**************");
        return nil;
    }
    
}
+ (NSString *)ColorStringWithindex:(NSInteger)index{
    
   return [[[self class]alloc]ColorStringWithindex:index];
}

#pragma  mark - 懒加载
//- (NSArray *)colorArray{
//    if (!_colorArray) {
//        _colorArray = @[@"FA0300",@"03FF07",@"08DDDB",@"FE6603",@"0057DD",@"FFFFFF",@"FF31AA",@"0"];
//    }
//    return _colorArray;
//}
@end
