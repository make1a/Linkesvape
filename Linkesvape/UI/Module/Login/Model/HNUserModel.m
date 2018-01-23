//
//  HNUserModel.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNUserModel.h"

@implementation HNUserModel
+ (HNUserModel *)shareInstance
{
    static HNUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[HNUserModel alloc] init];
    });
    return userModel;
}
- (void)clear{
    self.user_type = @"";
    self.uid = @"";
    self.username = @"";
}
@end
