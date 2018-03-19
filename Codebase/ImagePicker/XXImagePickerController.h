//
//  XXImagePickerController.h
//  NBPicker
//
//  Created by suger on 2018/3/13.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPickerConfig.h"
#import "XXImageManager.h"

@class XXImagePickerController;

@protocol XXImagePickerDelegate<NSObject>

//返回所有选择的媒体，model中的asset为PHAsset，使用manager来获取相应的内容 Return all medias. The asset of model is PHAsset instance. Fetch content of asset by manager.
- (void)imagePickerController:(XXImagePickerController *)picker didFinishPickingMedia:(NSArray<XXAssetModel *> *)assets;

//只返回图片类型，忽略其他媒体类型 Only return photos while ignore other medias
- (void)imagePickerController:(XXImagePickerController *)picker didFinishPickedPhotos:(NSArray<UIImage *> *)photos assets:(NSArray<XXAssetModel *> *)assets;

//只返回视频类型，忽略其他媒体类型 Only return videos while ignore other medias
- (void)imagePickerController:(XXImagePickerController *)picker didFinishPickedVideos:(NSArray<UIImage *> *)coverImgs assets:(NSArray<XXAssetModel *> *)assets;

@end

@interface XXImagePickerController : UINavigationController

@property (nonatomic, strong) XXPickerConfig *config;

@property (nonatomic, weak) id<XXImagePickerDelegate> pickerDelegate;

- (instancetype)initWithConfig:(XXPickerConfig *)config delegate:(id<XXImagePickerDelegate>)delegate;

@end
