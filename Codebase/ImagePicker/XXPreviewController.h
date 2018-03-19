//
//  XXPreviewController.h
//  NBPicker
//
//  Created by suger on 2018/3/14.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXAssetModel;

@protocol XXPreviewControllerDelegate <NSObject>

- (void)didSelectAsset:(XXAssetModel *)asset atIndex:(NSInteger)index;

- (void)didDeselectAsset:(XXAssetModel *)asset atIndex:(NSInteger)index;

@end

@interface XXPreviewController : UIViewController

@property (nonatomic, weak) id<XXPreviewControllerDelegate> delegate;

- (instancetype)initWithAssets:(NSArray *)assets atIndex:(NSInteger)index;

@end
