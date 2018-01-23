//
//  HNPlayListModel.m
//  Linkesvape
//
//  Created by make on 2018/1/9.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNPlayListModel.h"

@implementation HNPlayListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId": @"id"};
}
@end


@implementation HNPlayModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId": @"id"};
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@-%@",self.name,self.modelId];
}
@end
