//
//  XXPickerConfig.h
//  NBPicker
//
//  Created by suger on 2018/3/13.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTypes.h"

@interface XXPickerConfig : NSObject

@property (nonatomic, assign) NSInteger maxNumber;//最多可选，默认9

@property (nonatomic, assign) XXAlbumTypeOptions albumTypes;

@property (nonatomic, assign) XXAutoAlbumType autoAlbumType;//自动显示相册，默认无

@property (nonatomic, assign) XXAllowMediaTypeOptions mediaTypes;

+ (instancetype)defaultConfig;

@end
