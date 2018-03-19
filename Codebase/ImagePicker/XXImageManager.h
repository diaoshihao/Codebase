//
//  XXImageManager.h
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXAlbumModel.h"
#import "XXAssetModel.h"
#import "XXTypes.h"

@class AVPlayerItem;

@interface XXImageManager : NSObject

+ (instancetype)shareManager;

- (void)getAlbumsWithXXAlbumTypes:(XXAlbumTypeOptions)types compeletion:(void(^)(NSArray<XXAlbumModel *> *models))compeletion;

- (void)getAssetsFromModel:(XXAlbumModel *)model compeletion:(void(^)(NSArray<XXAssetModel *> *models))compeletion;

- (void)requestHighQualityImageWithAsset:(id)asset completeHandle:(void(^)(UIImage *image))handle;

- (void)requestVideoWithAsset:(id)asset completeHandle:(void(^)(AVPlayerItem *playerItem))handle;

@end
