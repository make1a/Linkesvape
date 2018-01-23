//
//  HNSingleLightModel.h
//  Linkesvape
//
//  Created by make on 2018/1/11.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HNCustomInfoModel: NSObject

//6个灯
@property (nonatomic,strong)NSMutableArray * lamps;
@property (nonatomic,copy)NSString * light;

@end




@interface HNSingleLightModel : NSObject
//  infos:[]  18个info
@property (nonatomic,strong)NSMutableArray * infos;

@end



@interface HNLightInfoModel :NSObject

@property (nonatomic,copy)NSString * color;

/**
 1.常亮  2.快闪 3.慢闪
 */
@property (nonatomic,copy)NSString * hz;


+ (NSString *)ColorStringWithindex:(NSInteger)index;
@end
