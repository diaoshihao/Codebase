//
//  SHPhotoBrowser.h
//  KTBook
//
//  Created by suger on 2018/1/23.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserDelegate <NSObject>



@end

@interface SHPhotoBrowser : UIViewController

+ (instancetype)browserWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index;

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index;

@end
