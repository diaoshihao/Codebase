//
//  XXTypes.h
//  NBPicker
//
//  Created by suger on 2018/3/13.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#ifndef XXTypes_h
#define XXTypes_h

//允许媒体类型
typedef NS_OPTIONS(NSUInteger, XXAllowMediaTypeOptions) {
    XXAllowMediaTypeOptionsAll = 0,
    XXAllowMediaTypeOptionsImage = 1 << 0,
    XXAllowMediaTypeOptionsVideo = 1 << 1,
    XXAllowMediaTypeOptionsAudio = 1 << 2,
};

//相册显示类型
typedef NS_OPTIONS(NSUInteger, XXAlbumTypeOptions) {
    XXAlbumTypeOptionsAny           = 0,        //默认全部显示
    XXAlbumTypeOptionsUserLibrary   = 1 << 0,   //相机胶卷
    XXAlbumTypeOptionsRecentlyAdded = 1 << 1,   //最近添加
    XXAlbumTypeOptionsVideos        = 1 << 2,   //视频
    XXAlbumTypeOptionsFavorites     = 1 << 3,   //个人收藏
    XXAlbumTypeOptionsTimelapses    = 1 << 4,   //延时摄影
    XXAlbumTypeOptionsBursts        = 1 << 5,   //连拍快照
    XXAlbumTypeOptionsSlomoVideos   = 1 << 6,   //慢动作
    XXAlbumTypeOptionsSelfPortraits = 1 << 7,   //自拍
    XXAlbumTypeOptionsScreenshots   = 1 << 8,   //屏幕快照
    XXAlbumTypeOptionsDepthEffect   = 1 << 9,   //景深效果
    XXAlbumTypeOptionsPanoramas     = 1 << 10,  //全景照片
    XXAlbumTypeOptionsLivePhotos    = 1 << 11,  //Live Photo
    XXAlbumTypeOptionsCustoms       = 1 << 12,  //用户创建的相册
};

//自动打开相册类型
typedef NS_ENUM(NSUInteger, XXAutoAlbumType) {
    XXAutoAlbumTypeNone             = 0,
    XXAutoAlbumTypeUserLibrary      = 1 << 0,
    XXAutoAlbumTypeRecentlyAdded    = 1 << 1,
    XXAutoAlbumTypeVideos           = 1 << 2,
};

#endif /* XXTypes_h */
