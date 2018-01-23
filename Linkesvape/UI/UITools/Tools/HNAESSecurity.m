//
//  HNAESSecurity.m
//  OptimalLive
//
//  Created by Sunwanwan on 2017/11/6.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNAESSecurity.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"

static NSString *gIV = @"AES_Pwd__AES_Pwd";

@implementation HNAESSecurity

+ (NSString *)returnKey
{
    NSString *string = [NSString stringWithFormat:@"%@%@",@"HongNiaoYouBo",kTOKEN];
    
    string = [string substringToIndex:16];
    
    return string;
}

+(NSString *)AES128Encrypt:(NSString *)plainText
{
    NSString *key = [self returnKey];
    
    if( ![self validKey:key] ){
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    unsigned long newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
        NSLog(@"diff is %d",diff);
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}

+(NSString *)AES128Decrypt:(NSString *)encryptText
{
    NSString *key = [self returnKey];
    
    if( ![self validKey:key] ){
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        NSString *decoded=[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return [self processDecodedString:decoded];
    }
    
    free(buffer);
    return nil;
}

+(BOOL)validKey:(NSString*)key
{
    if( key==nil || key.length != 16 ){
        return NO;
    }
    return YES;
}

+(NSString *)processDecodedString:(NSString *)decoded
{
    if( decoded==nil || decoded.length==0 ){
        return nil;
    }
    const char *tmpStr=[decoded UTF8String];
    int i=0;
    
    while( tmpStr[i]!='\0' )
    {
        i++;
    }
    NSString *final=[[NSString alloc]initWithBytes:tmpStr length:i encoding:NSUTF8StringEncoding];
    return final;
    
}

@end
