//
//  XXPickerConfig.m
//  NBPicker
//
//  Created by suger on 2018/3/13.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXPickerConfig.h"

@implementation XXPickerConfig

+ (instancetype)defaultConfig {
    return [[XXPickerConfig alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxNumber = 9;
        self.autoAlbumType = XXAutoAlbumTypeNone;
        self.albumTypes = XXAlbumTypeOptionsAny;
        self.mediaTypes = XXAllowMediaTypeOptionsAll;
    }
    return self;
}

@end
