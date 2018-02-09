//
//  SHImageProcessor.m
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "SHImageProcessor.h"

@implementation SHImageProcessor

+ (instancetype)shareProcessor {
    static SHImageProcessor *processor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [[SHImageProcessor alloc] init];
    });
    return processor;
}

@end
