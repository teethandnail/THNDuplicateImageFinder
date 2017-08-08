//
//  ViewController.m
//  THNDuplicateImageFinder
//
//  Created by ZhangHonglin on 2017/7/3.
//  Copyright © 2017年 ChengDao. All rights reserved.
//

#import "ViewController.h"
#import "THNDuplicateImageFinder.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSTextField *pathTextFiled;

@property (nonatomic, weak) IBOutlet NSTextView *resultTextView;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pathTextFiled setStringValue:@"/Users/HongLin/Documents/SVN_IOS/Git_Pod/NewCashier"];
    self.resultTextView.string = @"";
    self.resultTextView.editable = NO;
}

- (IBAction)clickButton:(NSButton*)sender {
    self.resultTextView.string = @"";
    
    NSString *path = self.pathTextFiled.stringValue;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.resultTextView.string = @"路径不存在";
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[c] 'png'"];
    NSArray *subPathArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSArray *filteredSubPathArray = [subPathArray filteredArrayUsingPredicate:predicate];
    NSArray *duplicateImageArray = [THNDuplicateImageFinder md5FindDuplicateImageAtPath:path subPathArray:filteredSubPathArray];
    
    if (duplicateImageArray.count == 0) {
        self.resultTextView.string = @"不存在重复图片";
    } else {
        self.resultTextView.string = [NSString stringWithFormat:@"内容重复的图片[数量 %ld]：\n%@", duplicateImageArray.count, duplicateImageArray];
    }
}

@end
