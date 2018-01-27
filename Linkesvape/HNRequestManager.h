//
//  HNRequestManager.h
//  OptimalLive
//
//  Created by Sunwanwan on 2017/8/31.
//  Copyright © 2017年 HN. All rights reserved.
//  请求类

#import <Foundation/Foundation.h>

// 网络请求类型
typedef NS_ENUM (NSInteger, HNRequestMethodType)
{
    HNRequestMethodTypeGET     = 0,
    HNRequestMethodTypePOST    = 1,
};

typedef void(^SuccessBlock)(id responseObject);

typedef void(^FaildBlock)(NSError *error);

typedef void(^DownSuccessBlock)(id responseObject,NSURL *filePath);

@interface HNRequestManager : NSObject

/**
 *  请求API
 *  type : 请求方式
 *  code : 请求接口API
 *  parameters :  请求参数， 可为nil
 *  headerParameters  : 请求头参数, 可为nil
 *  success  : 请求成功返回
 *  faild  : 请求失败返回
 */
+ (void)sendRequestWithRequestMethodType:(HNRequestMethodType)type
                          requestAPICode:(NSString *)code
                       requestParameters:(NSDictionary *)parameters
                           requestHeader:(NSDictionary *)headerParameters
                                 success:(SuccessBlock)success
                                   faild:(FaildBlock)faild;


/**
 *  图片上传API
 *  code : 请求接口API
 *  parameters : 请求参数
 *  headerParameters  : 请求头参数, 可为nil
 *  image : 图片， 可为nil
 *  success  : 请求成功返回
 *  faild  : 请求失败返回
 */
+ (void)uploadImageWithRequestAPICode:(NSString *)code
                    requestParameters:(NSDictionary *)parameters
                        requestHeader:(NSDictionary *)headerParameters
                                image:(UIImage *)image
                        success:(SuccessBlock)success
                          faild:(FaildBlock)faild;


/**
 *  视频上传API
 *  视频上传的code 在方法里面写了， 外部不用再传了
 *  fileName : 上传文件名称
 *  parameters : 请求参数
 *  headerParameters  : 请求头参数, 可为nil
 *  success  : 请求成功返回
 *  faild  : 请求失败返回
 */
+ (void)uploadVideoWithFileName:(NSString *)fileName
                requestParameters:(NSDictionary *)parameters
                    requestHeader:(NSDictionary *)headerParameters
                          success:(SuccessBlock)success
                            faild:(FaildBlock)faild;



/**
 文件下载

 @param urlString <#urlString description#>
 @param success <#success description#>
 @param faild <#faild description#>
 */
+(void)downWithFileUrlString:(NSString *)urlString
                     success:(DownSuccessBlock)success
                       faild:(FaildBlock)faild;
@end
