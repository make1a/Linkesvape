//
//  HNPlayListModel.h
//  Linkesvape
//
//  Created by make on 2018/1/9.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNPlayListModel : NSObject
@property (nonatomic,copy)NSString * modelId;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * num;
@property (nonatomic,copy)NSString * num_code;
@end


@interface HNPlayModel :NSObject

/**
 模式记录id
 */
@property (nonatomic,copy)NSString * modelId;

/**
 排序
 */
@property (nonatomic,copy)NSString * order_num;


/**
 模式id
 */
@property (nonatomic,copy)NSString * m_id;

@property (nonatomic,copy)NSString * name;
@end
