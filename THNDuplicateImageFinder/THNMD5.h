//
//  THNMD5.h
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/8/7.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNMD5 : NSObject

+ (NSString *)getFileMD5WithPath:(NSString*)path;

@end
