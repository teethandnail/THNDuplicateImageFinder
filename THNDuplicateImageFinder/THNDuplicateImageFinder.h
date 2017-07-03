//
//  THNDuplicateImageFinder.h
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNDuplicateImageFinder : NSObject

+ (NSArray *)findDuplicateWithPathHead:(NSString *)pathHead shortPathArray:(NSArray *)pathArray;

@end
