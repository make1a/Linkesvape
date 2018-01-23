//
//  HNBannerModel.h
//  Linkesvape
//
//  Created by make on 2018/1/4.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNBannerModel : NSObject
@property (nonatomic,copy)NSString * src;
@property (nonatomic,copy)NSString * target_info;
@end


/**************HNNewsModel*****************/
@interface HNNewsModel:NSObject
/** 2 **/
@property(nonatomic,copy) NSString *newsId;
/** 人民解放军首次执行天安门广场升国旗任务 **/
@property(nonatomic,copy) NSString *title;
/** url **/
@property(nonatomic,copy) NSString *title_img;
/** time **/
@property(nonatomic,copy) NSString *addtime;


@end
