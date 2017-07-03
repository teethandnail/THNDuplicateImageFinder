//
//  THNDuplicateImageFinder.m
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import "THNDuplicateImageFinder.h"
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*1024

@implementation THNDuplicateImageFinder

/*!
 * 查找图片内容相同的图片
 *
 */
+ (NSArray *)findDuplicateWithPathHead:(NSString *)pathHead shortPathArray:(NSArray *)pathArray {
    
    // 每个md5对应的图片数大于等于1
    NSMutableDictionary *exitDic = [NSMutableDictionary dictionary];
    
    for (NSString *imageName in pathArray) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", pathHead, imageName];
        
        NSString *itemMd5 = [THNDuplicateImageFinder getFileMD5WithPath:fullPath];
        if (!imageName || !itemMd5) {
            NSLog(@"error : name=%@,md5=%@", imageName, itemMd5);
            continue;
        }
        
        NSMutableArray *exitArray = exitDic[itemMd5];
        if (!exitArray) {
            NSMutableArray *itemNameArray = [NSMutableArray array];
            [itemNameArray addObject:imageName];
            [exitDic setObject:itemNameArray forKey:itemMd5];
        } else {
            [exitArray addObject:imageName];
        }
    }
    
    // md5对应的图片数大于1
    NSMutableArray *duplicateImageArray = [NSMutableArray array];
    
    for (NSString *itemMd5 in exitDic.allKeys) {
        NSArray *itemNameArray = exitDic[itemMd5];
        if (itemNameArray.count > 1) {
            [duplicateImageArray addObject:itemNameArray];
        }
    }
    
    return [NSArray arrayWithArray:duplicateImageArray];
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

@end
