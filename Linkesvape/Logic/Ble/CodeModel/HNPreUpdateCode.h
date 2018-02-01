//
//  HNPreUpdateCode.h
//  Linkesvape
//
//  Created by make on 2018/1/31.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNPreUpdateCode : NSObject
@property (nonatomic,copy)NSString * cmd;
@property (nonatomic,copy)NSString * pkg1;
/**数据总包数*/
@property (nonatomic,copy)NSString * pkg2;
@property (nonatomic,copy)NSString * totalString;
@property (nonatomic,copy)NSString * lengthString;
@end
