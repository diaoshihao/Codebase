//
//  SHImageLoader.m
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "SHImageLoader.h"

@implementation SHImageLoader

+ (instancetype)shareLoader {
    static SHImageLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[SHImageLoader alloc] init];
    });
    return loader;
}

- (void)loadImageWithUrl:(NSString *)url {
    if ([url hasPrefix:@"http"]) {
        
    } else {
        
    }
}

@end
