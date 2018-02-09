//
//  SHImageCache.h
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHImageCache : NSObject

+ (instancetype)shareCache;

- (UIImage *)imageWithUrl:(NSString *)url;

@end
