//
//  CameraViewController.h
//  KTBook
//
//  Created by suger on 2017/12/25.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@protocol CameraViewControllerDelegate <NSObject>

- (void)didPickedImageFromCamera:(CameraViewController *)camera image:(UIImage *)image;

@end

@interface CameraViewController : UIViewController

@property (nonatomic, weak) id<CameraViewControllerDelegate> delegate;

@end
