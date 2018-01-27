//
//  HNRequestManager.m
//  OptimalLive
//
//  Created by Sunwanwan on 2017/8/31.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNRequestManager.h"

#define UpLoadVideo @"/upload/video.php"   ///上传视频
#define VideoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"anchor.mp4"]

@implementation HNRequestManager

// 请求API
+ (void)sendRequestWithRequestMethodType:(HNRequestMethodType)type
                          requestAPICode:(NSString *)code
                       requestParameters:(NSDictionary *)parameters
                           requestHeader:(NSDictionary *)headerParameters
                                 success:(SuccessBlock)success
                                   faild:(FaildBlock)faild
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;  // 超时时间设置为10s
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    if (headerParameters != nil)
    {
        // 有自定义的请求头
        for (NSString *httpHeaderField in headerParameters.allKeys) {
            NSString *value = headerParameters[httpHeaderField];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    /************** 项目私有语言设置 *************/
    NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];
    [manager.requestSerializer setValue:language forHTTPHeaderField:@"Accept-Language"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    if (token.length >0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"authorization"];
    }
    /************** 项目私有语言设置 *************/
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",REQUEST,code];
    
    DLog(@"----- 请求的接口：%@ ------- 请求的参数： %@ ---------请求的token： %@",requestUrl,parameters,kTOKEN);
    
    if (type == HNRequestMethodTypeGET)
    {
        // Get请求
        [manager GET:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 在这里进行个特殊处理， 针对整个工程，当请求出现code = 403时， 说明被挤掉了， 要切换跟视图
            if (CODE == 403)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogin" object:nil];
                
                return ;
            }
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            faild(error);
        }];
    }
    else
    {
        // Post请求
        [manager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 在这里进行个特殊处理， 针对整个工程，当请求出现code = 403时， 说明被挤掉了， 要切换跟视图
            if (CODE == 403)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogin" object:nil];
                
                return ;
            }
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            faild(error);
        }];
    }
}

// 上传图片
+ (void)uploadImageWithRequestAPICode:(NSString *)code
                    requestParameters:(NSDictionary *)parameters
                        requestHeader:(NSDictionary *)headerParameters
                                image:(UIImage *)image
                              success:(SuccessBlock)success
                                faild:(FaildBlock)faild
{
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",REQUEST,code];
    NSData * imageData = nil;
    imageData = UIImagePNGRepresentation(image);
    
    if (imageData.length == 0) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    [manager POST:imageURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
    }];
}

// 上传视频
+ (void)uploadVideoWithFileName:(NSString *)fileName
              requestParameters:(NSDictionary *)parameters
                  requestHeader:(NSDictionary *)headerParameters
                        success:(SuccessBlock)success
                          faild:(FaildBlock)faild
{
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",REQUEST,UpLoadVideo];
    NSURL* url = [NSURL fileURLWithPath:VideoPath];
    NSData* videoData = [NSData dataWithContentsOfURL:url];
    
    [manager POST:imageURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType:@"mp4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary*dictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
    }];
}

/*
 第一个参数:请求对象
 第二个参数:progress 进度回调
 第三个参数:destination--(downloadTask-)
 在该block中告诉AFN应该把文件存放在什么位置,AFN内部会自动的完成文件的剪切处理
 targetPath:文件的临时存储路径(tmp)
 response:响应头信息
 返回值:文件的最终存储路径
 第四个参数:completionHandler 完成之后的回调
 filePath:文件路径 == 返回值
 */
+(void)downWithFileUrlString:(NSString *)urlString
                     success:(DownSuccessBlock)success
                       faild:(FaildBlock)faild{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress){
        
        //进度回调,可在此监听下载进度(已经下载的大小/文件总大小)
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response){
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath,
                          NSError * _Nullable error) {
        if (!error) {
            if (success) {
                success(response,filePath);
            }
        }else{
            faild(error);
        }
        NSLog(@"filePath:%@",filePath);
        
    }];
    
    [download resume];
    
}

@end
