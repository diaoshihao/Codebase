//
//  ContentScrollView.h
//  KTBook
//
//  Created by suger on 2018/1/23.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentScrollView;
@protocol ContentScrollViewDelegate <NSObject>

- (void)contentViewDidScroll:(ContentScrollView *)contentView toIndex:(NSUInteger)index;

@end

@protocol ContentScrollViewDataSource <NSObject>

- (NSUInteger)firstIndexInContentView:(ContentScrollView *)contentView;

- (NSUInteger)numberOfImagesInContentView:(ContentScrollView *)contentView;

- (UIImage *)contentView:(ContentScrollView *)contentView imageForIndex:(NSUInteger)index;

@end

@interface ContentScrollView : UIScrollView

@property (nonatomic, weak) id<ContentScrollViewDelegate> contentDelegate;

@property (nonatomic, weak) id<ContentScrollViewDataSource> contentDataSource;

- (void)setupPhotos:(NSArray *)photos;

- (void)shouldZoomingForIndex:(NSUInteger)index atPoint:(CGPoint)point;

@end
