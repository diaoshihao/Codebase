//
//  SHImageManager.m
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "SHImageManager.h"
#import "SHImageCache.h"
#import "SHImageLoader.h"
#import "SHImageProcessor.h"

@interface SHImageManager()

@property (nonatomic, strong) SHImageCache *imageCache;

@property (nonatomic, strong) SHImageLoader *imageLoader;

@property (nonatomic, strong) SHImageProcessor *imageProcessor;

@end

@implementation SHImageManager

+ (instancetype)shareManager {
    static SHImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHImageManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageCache = [SHImageCache shareCache];
        self.imageLoader = [SHImageLoader shareLoader];
        self.imageProcessor = [SHImageProcessor shareProcessor];
    }
    return self;
}

- (void)requestImageWithUrl:(NSString *)url size:(CGSize)size complete:(CompleteHandle)completeHandle {
    UIImage *image = [self.imageCache imageWithUrl:url];
    if (image) {
        completeHandle(image, nil);
    } else {
        [self requestFromLoader:url];
    }
}

- (BOOL)hasSameRequest:(NSString *)url {
    return NO;
}

- (void)requestFromLoader:(NSString *)url {
    [self.imageCache imageWithUrl:url];
}

@end
