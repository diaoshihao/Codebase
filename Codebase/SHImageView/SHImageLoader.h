//
//  SHImageLoader.h
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHImageLoader : NSObject

+ (instancetype)shareLoader;

- (void)loadImageWithUrl:(NSString *)url;

@end
