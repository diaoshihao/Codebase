//
//  XXImageManager.m
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXImageManager.h"
#import <Photos/Photos.h>

@interface XXImageManager()

@end

@implementation XXImageManager

+ (instancetype)shareManager {
    static XXImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XXImageManager alloc] init];
    });
    return manager;
}

- (void)getAlbumsWithXXAlbumTypes:(XXAlbumTypeOptions)types compeletion:(void(^)(NSArray<XXAlbumModel *> *models))compeletion {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if (types == XXAlbumTypeOptionsAny) {
        
        [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeAny]];
        [arr addObjectsFromArray:[self getAlbumWithSubtype:PHAssetCollectionSubtypeAlbumRegular]];
        
    } else {
        
        types & XXAlbumTypeOptionsUserLibrary ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsRecentlyAdded ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsVideos ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumVideos]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsFavorites ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumFavorites]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsTimelapses ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumTimelapses]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsBursts ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumBursts]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsSlomoVideos ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumSlomoVideos]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsSelfPortraits ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsScreenshots ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumScreenshots]] : [self emptyMethod];
        
        types & XXAlbumTypeOptionsPanoramas ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumPanoramas]] : [self emptyMethod];
        
        if (@available(iOS 10.2, *)) {
            types & XXAlbumTypeOptionsDepthEffect ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumDepthEffect]] : [self emptyMethod];
        }
        
        if (@available(iOS 10.3, *)) {
            types & XXAlbumTypeOptionsLivePhotos ? [arr addObjectsFromArray:[self getSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumLivePhotos]] : [self emptyMethod];
        }
        
        types & XXAlbumTypeOptionsCustoms ? [arr addObjectsFromArray:[self getAlbumWithSubtype:PHAssetCollectionSubtypeAlbumRegular]] : [self emptyMethod];
    }
    
    if (compeletion) {
        compeletion(arr);
    }
}

- (void)getAssetsFromModel:(XXAlbumModel *)albumModel compeletion:(void(^)(NSArray<XXAssetModel *> *models))compeletion {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumModel.identifier] options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [[PHAsset fetchAssetsInAssetCollection:obj options:nil] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self requestImageFromAsset:obj handle:^(XXAssetModel *assetModel, BOOL isHighQulaty) {
                [arr addObject:assetModel];
                
                if (compeletion) {
                    compeletion(arr);
                }
                
            }];
        
        }];
        
    }];
    
}

- (void)requestHighQualityImageWithAsset:(id)asset completeHandle:(void(^)(UIImage *image))handle {
    
    if (![asset isKindOfClass:[PHAsset class]]) {
        handle(nil);
        return;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        handle(result);
    }];
}

- (void)requestVideoWithAsset:(id)asset completeHandle:(void(^)(AVPlayerItem *playerItem))handle {
    if (![asset isKindOfClass:[PHAsset class]]) {
        handle(nil);
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    [[PHCachingImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        handle(playerItem);
    }];
}

#pragma mark - private

- (void)emptyMethod {
    
}

//智能相册
- (NSArray *)getSmartAlbumWithSubtype:(PHAssetCollectionSubtype)subtype {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.includeHiddenAssets = NO;
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:subtype options:fetchOptions];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:result.count];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([obj.localizedTitle isEqualToString:@"Hidden"] || [obj.localizedTitle isEqualToString:@"已隐藏"])) {
            XXAlbumModel *model = [[XXAlbumModel alloc] init];
            model.name = obj.localizedTitle;
            model.identifier = obj.localIdentifier;
            [self getCoverImageAndImgCountWithAlbumModel:model];
            [array addObject:model];
        }
    }];
    return array;
}

//自建相册
- (NSArray *)getAlbumWithSubtype:(PHAssetCollectionSubtype)subtype {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.includeHiddenAssets = NO;
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:subtype options:fetchOptions];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:result.count];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            if (!([obj.localizedTitle isEqualToString:@"Hidden"] || [obj.localizedTitle isEqualToString:@"已隐藏"])) {
                XXAlbumModel *model = [[XXAlbumModel alloc] init];
                model.name = obj.localizedTitle;
                model.identifier = obj.localIdentifier;
                [self getCoverImageAndImgCountWithAlbumModel:model];
                [array addObject:model];
            }
        }
    }];
    return array;
}

//获取封面和数量
- (void)getCoverImageAndImgCountWithAlbumModel:(XXAlbumModel *)model {
    PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[model.identifier] options:nil].lastObject;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    model.imgCount = [NSString stringWithFormat:@"%ld",fetchResult.count];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHAsset *asset = fetchResult.lastObject;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        model.coverImg = result;
    }];
}

- (void)requestImageFromAsset:(PHAsset *)asset handle:(void(^)(XXAssetModel *assetModel, BOOL isHighQulaty))handle {
    XXAssetModel *model = [[XXAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.isDegraded = YES;
    model.allowSelect = YES;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        model.mediaType = XXAssetMediaTypePhoto;
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        model.mediaType = XXAssetMediaTypeVideo;
        NSInteger duration = asset.duration;
        model.videoDuration = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",duration / 3600,duration % 3600 / 60,duration % 3600 % 60];
    } else if (asset.mediaType == PHAssetMediaTypeAudio) {
        model.mediaType = XXAssetMediaTypeAudio;
    }
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(1, 1) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if ([result isKindOfClass:[UIImage class]]) {
            model.image = result;
            model.requestID = [info[PHImageResultRequestIDKey] integerValue];
            
            handle(model, ![info[PHImageResultIsDegradedKey] boolValue]);
        }
        
    }];
}


@end
