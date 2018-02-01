//
//  NSString+HNFilter.h
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/20.
//  Copyright © 2017年 HN. All rights reserved.
//  字符串过滤

#import <Foundation/Foundation.h>

@interface NSString (HNFilter)

// 字符串过滤掉两端空字符串和换行符
- (NSString *)filterLeftAndRightEmptyString;

// 字符串过滤掉空字符串和换行符
- (NSString *)filterEmptyString;

// 判断是否含有表情
- (BOOL)stringContainsEmoji;

// 字符串过滤掉emoji
+ (NSString *)filterEmoji:(NSString *)string;

// 文字转化为表情
- (NSAttributedString *)emotionStringWithEmojiHeight:(CGFloat)WH;

- (int)textLength;
- (BOOL)isSpecialCharacters;

+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)str;

//16进制字串转sacil码
+ (NSString *)ascilNumberToString:(NSString *)hexStr;

//十进制准换为十六进制字符串
+ (NSString *)getHexByDecimal:(NSInteger)decimal;
// 16进制转10进制
+ (NSString *)hexStringToDecima:(NSString *)hexString;
+ (NSString *)padingZero:(NSString *)str length:(NSInteger)length;


/**
 获取小模式str

 @param str str description
 @param length length description
 @return return value description
 */
+(NSString *)getSmallModeString:(NSString *)str length:(NSInteger)length;
@end
