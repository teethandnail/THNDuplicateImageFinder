//
//  THNDuplicateNameFinder.m
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import "THNDuplicateNameFinder.h"

@implementation THNDuplicateNameFinder

+ (NSArray *)findDuplicateNameWithPathArray:(NSArray *)pathArray {
    
    NSMutableDictionary *exitDic = [NSMutableDictionary dictionary];
    
    for (NSString *imagePath in pathArray) {
        NSString *imageName = imagePath.lastPathComponent;
        
        if (!imageName) {
            continue;
        }
        
        NSMutableArray *exitArray = exitDic[imageName];
        if (!exitArray) {
            NSMutableArray *itemNameArray = [NSMutableArray array];
            [itemNameArray addObject:imagePath];
            [exitDic setObject:itemNameArray forKey:imageName];
        } else {
            [exitArray addObject:imagePath];
        }
    }
    
    // md5对应的图片数大于1
    NSMutableArray *duplicateNameArray = [NSMutableArray array];
    
    for (NSString *imageName in exitDic.allKeys) {
        NSArray *itemNameArray = exitDic[imageName];
        if (itemNameArray.count > 1) {
            [duplicateNameArray addObject:itemNameArray];
        }
    }
    
    return [NSArray arrayWithArray:duplicateNameArray];
    
}


@end
