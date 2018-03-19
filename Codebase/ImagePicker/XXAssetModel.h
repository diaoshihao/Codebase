//
//  XXAssetModel.h
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

typedef NS_ENUM(NSUInteger, XXAssetMediaType) {
    XXAssetMediaTypePhoto,
    XXAssetMediaTypeVideo,
    XXAssetMediaTypeAudio,
};

@interface XXAssetModel : NSObject

@property (nonatomic, strong) id asset;

@property (nonatomic, assign) XXAssetMediaType mediaType;

@property (nonatomic, strong) UIImage *image;//if media is video,the image is cover image

@property (nonatomic, strong) NSString *videoDuration;

@property (nonatomic, assign) BOOL isDegraded; //是否缩略图，默认YES

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL allowSelect;

@property (nonatomic, assign) NSUInteger requestID;

@end
