//
//  HNTools.m
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/18.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNTools.h"
//#import <Reachability.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+ColorImage.h"
//#import "HNDownloadManager.h"
//#import "SSZipArchive.h"

@implementation HNTools

+ (NSString *)pictureStr:(NSString *)sufficx
{
    if ([sufficx hasPrefix:@"http"])
    {
        return sufficx;
    }
    else
    {
        return imageDomain(sufficx);
    }
}

// 请求地址的拼接
+ (NSString *)urlstrSuffix:(NSArray *)key withValue:(NSArray *)value with:(NSString *)suffix
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@?",suffix];
    for (int i = 0; i < key.count; i ++) {
        if (i == key.count-1) {
            [url appendFormat:@"%@=%@",key[i],value[i]];
        }else{
            [url appendFormat:@"%@=%@&",key[i],value[i]];
        }
    }
    if ([self IsChinese:[NSString stringWithFormat:@"aa!@#$%@%@)",@"^&*(",url]]) {  //当有中文的时候记得进行UTF8转码
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        NSString *str = url;
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        
        return str;
    }
    return url;
}

//判断是否有中文
+ (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

// 属性文字
+(NSMutableAttributedString *)getAttributedString:(NSString *)allString withStringAttributedDic:(NSDictionary *)dic withSubString:(NSString *)subString withSubStringAttributeDic:(NSDictionary *)subDic
{
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc]initWithString:allString attributes:dic];
    NSRange range = [allString rangeOfString:subString];
    [resultString addAttributes:subDic range:range];
    return resultString;
}

//获取字符串大小
+(CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size{
    
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFontSize(fontSize)} context:nil];
    return rect;
}

// 时间戳转时间
+ (NSString *)turnTimeTimestamp:(NSString *)timeStamp withType:(NSString *)type
{
    NSTimeInterval time=[timeStamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:type];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

// 将时间戳转换为多少分钟前
+ (NSString *)turnTimeForTimestamp:(NSString *)timeStamp showDetail:(BOOL)showDetail
{
    /*
     *、1、当天内，显示四个时段的时间，时段包括凌晨、上午、下午、晚上、凌晨。格式如下午16：30.
     * 1）凌晨定义：00：00--05：00
     * 2）上午定义：05：01--12：00
     * 3）下午定义：12：01--06：00
     * 4）晚上定义：06：01--23：59
     * 2、昨天的则显示昨天。
     * 3、昨天以前的则显示年/月/日，如2017/5/11。
     */
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    
    result = [self getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    if(nowDateComponents.day == msgDateComponents.day) //同一天,显示时间
    {
        result = [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
    }
    else if(nowDateComponents.day == (msgDateComponents.day+1))//昨天
    {
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd/%02ld/%02ld", msgDateComponents.year, msgDateComponents.month, (long)msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

// 将一段时间转换 eg：5分钟转化为00：05：00
+ (NSString *)changMinuteToTime:(NSString *)minute
{
    NSInteger time = [minute integerValue];
    if(time < 60)
    {
        
        return [NSString stringWithFormat:@"00:00:%02zd",time];
        
    }
    else
    {
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",time/3600,time/60,time%60];
    }

}

// 验证手机号码是否有效
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 验证邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断身份证是否是真实的
+ (BOOL)isValidateIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]){
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag){
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value  substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value  substringWithRange:NSMakeRange(3,1)].intValue + [value  substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value  substringWithRange:NSMakeRange(4,1)].intValue + [value  substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value  substringWithRange:NSMakeRange(5,1)].intValue + [value  substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value  substringWithRange:NSMakeRange(6,1)].intValue + [value  substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value  substringWithRange:NSMakeRange(7,1)].intValue *1 + [value  substringWithRange:NSMakeRange(8,1)].intValue *6 + [value  substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
            
        default:
            return NO;
            
    }
}

/*

 //支持单次获得网络状态
+(NSString *)networkStatusChangeApple
{
 
     NotReachable = 0,  没有网络
     ReachableViaWiFi,  WIFI
     ReachableViaWWAN   3G|4G
 
    //获得蜂窝网络的Reachability对象
    if([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)
    {
        DLog(@"3G|4G");
        
        return NetWork_MobileNet;
    }
    
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi)
    {
        DLog(@"wifi");
        
        return NetWork_WIFI;
    }
    
    return NetWork_NONET;
}
*/


#pragma mark -----------------------------  项目相关 ---------------------

// 等比例压缩图片
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 两个时间戳是否相隔5分钟
+ (BOOL)timeIntervalIsSpaceFiveMinutes:(NSString *)lastTime nowTime:(NSString *)nowTime
{    
    NSTimeInterval startTime = [lastTime doubleValue];
    NSTimeInterval endTime = [nowTime doubleValue];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = endTime - startTime;
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 300)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// MD5加密
+ (NSString *)md5To32bit:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr),digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

// json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)json
{
    if (json == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 根据用户等级返回背景图片名称
+ (UIImage *)returnBackgroundImageNameWithLevel:(NSString *)level
{
    if ([level integerValue] <= 10)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0x42a5f5, 1.0)];
    }
    else if ([level integerValue] > 10 && [level integerValue] <= 20)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0x11d680, 1.0)];
    }
    else if ([level integerValue] > 20 && [level integerValue] <= 30)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xf87a67, 1.0)];
    }
    else if ([level integerValue] > 30 && [level integerValue] <= 40)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xec51a8, 1.0)];
    }
    else if ([level integerValue] > 40 && [level integerValue] <= 50)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xf35164, 1.0)];
    }
    else if ([level integerValue] > 50 && [level integerValue] <= 60)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xc64ad9, 1.0)];
    }
    else if ([level integerValue] > 60 && [level integerValue] <= 70)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0x81cb21, 1.0)];
    }
    else if ([level integerValue] > 70 && [level integerValue] <= 80)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0x63dfde, 1.0)];
    }
    else if ([level integerValue] > 80 && [level integerValue] <= 90)
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xea7320, 1.0)];
    }
    else
    {
        return [UIImage imageWithCustomColor:UIColorFromHEXA(0xfd596b, 1.0)];
    }
}

// 大礼物动画名称数组
+ (NSArray *)BigGiftNameArray
{    
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    
    NSString *fileName;
    NSMutableArray *array = [NSMutableArray array];
    while (fileName = [dirEnum nextObject])
    {
        [array addObject:fileName];
    }
    
    return array;
}

// 获取大礼物动画图片数组
+ (NSMutableArray *)getBigGiftPictureArray:(NSString *)key
{
    NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:fullpath];
    
    NSString *fileName;
    NSMutableArray *array = [NSMutableArray array];
    while (fileName = [dirEnum nextObject])
    {
         [array addObject:fileName];
    }
    
    // 数组排序
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray2 = [array sortedArrayUsingComparator:sort];
    
    // 数据组装
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in resultArray2)
    {
        NSString *path =  [fullpath stringByAppendingPathComponent:name];
        UIImage * image = [UIImage imageWithContentsOfFile:path];
        if (image != nil)
        {
            [images addObject:image];
        }
    }
    
    return images;
}

// 处理二维码模糊的问题
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

/*
+ (void)downloadAndZipArchiveWithGiftModel:(HNGiftListModel *)model
{
    if (model.animation.length > 0 && [model.animation hasPrefix:@"http"])
    {
        NSString *fileName = [NSString stringWithFormat:@"%@_%@",model.giftId,model.name];
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
        NSString *temppath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:fileName];
        
        NSURL *url = [NSURL URLWithString:model.animation];
        HNDownloadManager *manager = [HNDownloadManager resumeManagerWithURL:url targetPath:temppath success:^{
            
            DLog(@"success");
            
            if ([SSZipArchive unzipFileAtPath:temppath toDestination:fullpath])
            {
                DLog(@"成功解压");
                
                // 删除压缩包
                [[NSFileManager defaultManager] removeItemAtPath:temppath error:nil];
                
                
                // 大礼物解压成功发送一个通知到直播间显示
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZipArchiveSuccess" object:nil userInfo:@{@"fileName" : fileName,@"model" : model}];
            }
            
        } failure:^(NSError *error) {
            
            DLog(@"failure");
            
        } progress:^(long long totalReceivedContentLength, long long totalContentLength) {
            
            float percent = 1.0 * totalReceivedContentLength / totalContentLength;
            NSString *strPersent = [[NSString alloc]initWithFormat:@"%.f", percent *100];
            DLog(@"%@", [NSString stringWithFormat:@"已下载%@%%", strPersent]);
        }];
        
        [manager start];
    }
}
*/

// 保存图片到沙盒
+ (void)saveImage:(UIImage *)tempImage withName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

// 根据图片名从获取图片路径
+ (NSString *)getImagePathWithName:(NSString *)name
{
    NSString *documentsFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* fullPathToFile = [documentsFile stringByAppendingPathComponent:name];
    
    return fullPathToFile;
}

@end
