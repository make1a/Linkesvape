//
//  HNDFUModel.h
//  Linkesvape
//
//  Created by make on 2018/1/22.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNDFUModel : NSObject

/**命令码*/
@property (nonatomic,copy)NSString * cmd;
/**
 数据总包数  pkg由大到小进行传输，如果是0表示最后一包。
 eg：共发送3包数据，pag分别是2、1、0；如果只有一包数据那么pkg就是0。
 */
@property (nonatomic,copy)NSString * pkg1;
/**数据总包数*/
@property (nonatomic,copy)NSString * pkg2;

@property (nonatomic,copy)NSString * O;
@property (nonatomic,copy)NSString * T;
@property (nonatomic,copy)NSString * A;




/**
 开始OTA
 */
+ (void)sendOTACode;
@end
