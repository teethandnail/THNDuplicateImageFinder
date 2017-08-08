//
//  THNDuplicateImageFinder.h
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNDuplicateImageFinder : NSObject

/**
 * 通过图片的md5值，找出重复的图片
 *
 * @param path 工程主目录
 * @param subPathArray 图片在工程目录中的位置
 * @return 重复图片数组
 */
+ (NSArray *)md5FindDuplicateImageAtPath:(NSString *)path subPathArray:(NSArray *)subPathArray;

@end
