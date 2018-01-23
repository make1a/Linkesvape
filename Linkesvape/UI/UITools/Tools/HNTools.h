//
//  HNTools.h
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/18.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HNTools : NSObject

// 图片加载显示
+ (NSString *)pictureStr:(NSString *)sufficx;

// 请求地址的拼接
+ (NSString *)urlstrSuffix:(NSArray *)key withValue:(NSArray *)value with:(NSString *)suffix;

// 属性文字
+(NSMutableAttributedString *)getAttributedString:(NSString *)allString withStringAttributedDic:(NSDictionary *)dic withSubString:(NSString *)subString withSubStringAttributeDic:(NSDictionary *)subDic;

// 获取字符串大小
+(CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size;

// 时间戳转时间
+ (NSString *)turnTimeTimestamp:(NSString *)timeStamp withType:(NSString *)type;

// 将时间戳转换为多少分钟前 (按照时间规格转换)
+ (NSString *)turnTimeForTimestamp:(NSString *)timeStamp showDetail:(BOOL)showDetail;

// 将一段时间转换 eg：5分钟转化为00：05：00
+ (NSString *)changMinuteToTime:(NSString *)minute;

// 验证手机号码是否有效
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 验证邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString *)email;

// 判断身份证是否是真实的
+ (BOOL)isValidateIDCardNumber:(NSString *)value;

// 支持单次获得网络状态
+ (NSString *)networkStatusChangeApple;


#pragma mark -----------------------------  项目相关 ---------------------

// 等比例压缩图片
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

// 两个时间戳是否相隔5分钟
+ (BOOL)timeIntervalIsSpaceFiveMinutes:(NSString *)lastTime nowTime:(NSString *)nowTime;

// MD5加密
+ (NSString *)md5To32bit:(NSString *)str;

// json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)json;

// 根据用户等级返回背景图片名称
+ (UIImage *)returnBackgroundImageNameWithLevel:(NSString *)level;

// 大礼物动画名称数组
+ (NSArray *)BigGiftNameArray;

// 获取大礼物动画图片数组
+ (NSMutableArray *)getBigGiftPictureArray:(NSString *)key;

// 处理二维码模糊的问题
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

// 下载解压大礼物
//+ (void)downloadAndZipArchiveWithGiftModel:(HNGiftListModel *)model;

// 保存图片到沙盒
+ (void)saveImage:(UIImage *)tempImage withName:(NSString *)imageName;

// 根据图片名从获取图片路径
+ (NSString *)getImagePathWithName:(NSString *)name;


@end
