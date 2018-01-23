//
//  HNAESSecurity.h
//  OptimalLive
//
//  Created by Sunwanwan on 2017/11/6.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAESSecurity : NSObject

#pragma mark -加密
+(NSString *)AES128Encrypt:(NSString *)plainText;

#pragma mark -解密
+(NSString *)AES128Decrypt:(NSString *)encryptText;


@end
