//
//  SHImageCache.m
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "SHImageCache.h"

@implementation SHImageCache

+ (instancetype)shareCache {
    static SHImageCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[SHImageCache alloc] init];
    });
    return cache;
}

@end
