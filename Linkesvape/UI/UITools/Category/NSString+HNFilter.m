//
//  NSString+HNFilter.m
//  LiveShow
//
//  Created by Sunwanwan on 2017/7/20.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "NSString+HNFilter.h"
//#import "NaturalData.h"
//#import "HNEmojiContact.h"

@implementation NSString (HNFilter)


- (NSString *)filterLeftAndRightEmptyString
{
    NSString *filerString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return filerString;
}

- (NSString *)filterEmptyString
{
    NSString *filerString = [self filterLeftAndRightEmptyString];
    filerString = [filerString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return filerString;
}

// 判断是否含有表情
- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSString *)filterEmoji:(NSString *)string
{
    __block NSString *newText = @"";
    
    BOOL isContainsEmoji = [string stringContainsEmoji];
    if (isContainsEmoji)
    {
        if (string.length == 1)
        {
            newText = [string substringToIndex:string.length - 1];
        }
        else
        {
            newText = [string substringToIndex:string.length - 2];
        }
        
    }
    else
    {
        newText = string;
    }
    
    return newText;
}
/*
- (NSAttributedString *)emotionStringWithEmojiHeight:(CGFloat)WH
{
    NSMutableArray *emotions = [NSMutableArray array];
    
    NSArray *imageNameArray = [NaturalData shareInStance].imageFaceArray;
    NSArray *faceNameArray = [NaturalData shareInStance].faceArray;
    for (int i = 0; i<imageNameArray.count; i++)
    {
        HNEmojiContact *emotion = [HNEmojiContact emotionWithChs:faceNameArray[i] png:imageNameArray[i]];
        [emotions addObject:emotion];
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *subStr = [self substringWithRange:range];
        
        for (int i = 0; i < emotions.count; i ++)
        {
            HNEmojiContact *emotion = emotions[i];
            if ([emotion.chs isEqualToString:subStr])
            {
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //这个-3 需要自己调整。。
                textAttachment.bounds = CGRectMake(0, -5, WH, WH);
                NSString *emojiString = [NSString stringWithFormat:@"%@",emotion.png];
                textAttachment.image = [UIImage imageNamed:emojiString];
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    return attributeString;
    
}
 */
-  (int)textLength {
    
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

-(BOOL)isSpecialCharacters
{
    NSCharacterSet *ValidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange Range = [self rangeOfCharacterFromSet:ValidCharacters];
    if (Range.location != NSNotFound)
    {
        NSLog(@"包含特殊字符");
    }
    return Range.location!=NSNotFound;
}


+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
//    DLog(@"hexdata: %@", hexData);
    return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


+ (NSString *)ascilNumberToString:(NSString *)hexStr{
    NSMutableString * reslutStr = [@"" mutableCopy];
    for (int i = 0; i<hexStr.length; i+=2) {
       int code = [self numberHexString:[hexStr substringWithRange:NSMakeRange(i, 2)]];
        [reslutStr appendString:[NSString stringWithFormat:@"%c",code]];
    }
    return reslutStr;
}

+ (int) numberHexString:(NSString *)aHexString{    // 为空,直接返回.
    if (nil == aHexString){
        return 0;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return [hexNumber intValue];
}



+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}


+ (NSString *)padingZero:(NSString *)str length:(NSInteger)length{
    NSString *string = nil;
    if (str.length==length) {
        return str;
    }
    if (str.length<length) {
        NSUInteger inter = length-str.length;
        for (int i=0;i< inter; i++) {
            string = [NSString stringWithFormat:@"0%@",str];
            str = string;
        }
    }
    return string;
}
//十进制准换为十六进制字符串
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)hexStringToDecima:(NSString *)hexString{
    
    NSMutableString *code = [@"" mutableCopy];
    for (int i = 0; i<hexString.length/2; i+=2) {
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 2)];
        int number = [self numberHexString:str];
        [code appendFormat:@"%d",number];
    }
    return code;
}


+(NSString *)getSmallModeString:(NSString *)str length:(NSInteger)length{
    str = [self padingZero:str length:length];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i<str.length/2; i++) {
        [string appendString:[str substringWithRange:NSMakeRange(length-2*(i+1), 2)]];
    }
    return string;
}

+(NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 +1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i =0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
        NSLog(@"myBuffer is %c",myBuffer[i /2] );
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"———字符串=======%@",unicodeString);
    return unicodeString;
}
@end
