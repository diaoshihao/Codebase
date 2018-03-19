//
//  XXImageViewController.h
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXAlbumModel;

@protocol XXImageViewControllerDelegate<NSObject>


@end


@interface XXImageViewController : UIViewController

@property (nonatomic, strong) XXAlbumModel *model;

@end
