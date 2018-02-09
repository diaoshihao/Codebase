//
//  UIView+Extension.h
//  Codebase
//
//  Created by suger on 2017/10/30.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@end
