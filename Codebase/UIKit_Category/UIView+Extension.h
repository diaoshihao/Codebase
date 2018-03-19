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

@property (nonatomic, strong, readonly) UIViewController *currentViewController;


- (void)cornerRadius:(CGFloat)radius;

- (void)cornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)roundingConers;

@end
