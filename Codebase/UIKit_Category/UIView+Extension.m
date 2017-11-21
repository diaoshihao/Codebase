//
//  UIView+Extension.m
//  Codebase
//
//  Created by suger on 2017/10/30.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - frame

- (CGFloat)hao_x {
    return self.frame.origin.x;
}

- (void)setHao_x:(CGFloat)hao_x {
    CGRect frame = self.frame;
    frame.origin.x = hao_x;
    self.frame = frame;
}

- (CGFloat)hao_y {
    return self.frame.origin.y;
}

- (void)setHao_y:(CGFloat)hao_y {
    CGRect frame = self.frame;
    frame.origin.y = hao_y;
    self.frame = frame;
}

- (CGFloat)hao_centerX {
    return self.center.x;
}

- (void)setHao_centerX:(CGFloat)hao_centerX {
    CGPoint center = self.center;
    center.x = hao_centerX;
    self.center = center;
}

- (CGFloat)hao_centerY {
    return self.center.y;
}

- (void)setHao_centerY:(CGFloat)hao_centerY {
    CGPoint center = self.center;
    center.y = hao_centerY;
    self.center = center;
}

- (CGFloat)hao_width {
    return self.frame.size.width;
}

- (void)setHao_width:(CGFloat)hao_width {
    CGRect frame = self.frame;
    frame.size.width = hao_width;
    self.frame = frame;
}

- (CGFloat)hao_height {
    return self.frame.size.height;
}

- (void)setHao_height:(CGFloat)hao_height {
    CGRect frame = self.frame;
    frame.size.height = hao_height;
    self.frame = frame;
}


- (UIViewController *)currentViewController {
    UIResponder *nextResponder = [self nextResponder];
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = [nextResponder nextResponder];
    } while (nextResponder != nil);
    return nil;
}

@end
