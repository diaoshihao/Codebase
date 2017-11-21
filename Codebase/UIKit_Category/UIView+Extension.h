//
//  UIView+Extension.h
//  Codebase
//
//  Created by suger on 2017/10/30.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat hao_x;

@property (nonatomic, assign) CGFloat hao_y;

@property (nonatomic, assign) CGFloat hao_centerX;

@property (nonatomic, assign) CGFloat hao_centerY;

@property (nonatomic, assign) CGFloat hao_width;

@property (nonatomic, assign) CGFloat hao_height;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@end
