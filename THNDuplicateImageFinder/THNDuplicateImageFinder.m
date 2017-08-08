//
//  THNDuplicateImageFinder.m
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import "THNDuplicateImageFinder.h"
#import "THNMD5.h"

@implementation THNDuplicateImageFinder

/**
 * 通过图片的md5值，找出重复的图片
 *
 * @param path 工程主目录
 * @param subPathArray 图片在工程目录中的位置
 * @return 重复图片数组
 */
+ (NSArray *)md5FindDuplicateImageAtPath:(NSString *)path subPathArray:(NSArray *)subPathArray {
    
    // 思路：把相同md5值的图片放入同一数组。如果数组元素数>1，该数组里的图片就是重复图片
    
    NSMutableDictionary *imagesDic = [NSMutableDictionary dictionary];
    for (NSString *subPath in subPathArray) {
        // 算出图片的md5值
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", path, subPath];
        NSString *itemMd5 = [THNMD5 getFileMD5WithPath:imagePath];
        
        if (!subPath || !itemMd5) {
            continue;
        }
        
        // md5值相同的图片放入同一数组
        NSMutableArray *exitArray = imagesDic[itemMd5];
        if (!exitArray) {
            NSMutableArray *itemNameArray = [NSMutableArray array];
            [itemNameArray addObject:subPath];
            [imagesDic setObject:itemNameArray forKey:itemMd5];
        } else {
            [exitArray addObject:subPath];
        }
    }
    
    // 找图片数>1的数组，放入结果数组中
    NSMutableArray *resultsArray = [NSMutableArray array];
    
    for (NSString *itemMd5 in imagesDic.allKeys) {
        NSArray *itemNameArray = imagesDic[itemMd5];
        if (itemNameArray.count > 1) {
            [resultsArray addObject:itemNameArray];
        }
    }
    
    return [NSArray arrayWithArray:resultsArray];
}

@end
