//
//  HNUserModel.h
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUserModel : NSObject

@property(nonatomic,copy) NSString *user_type;

@property(nonatomic,copy) NSString *uid;

@property(nonatomic,copy) NSString *username;

+ (HNUserModel *)shareInstance;

- (void)clear;
@end
