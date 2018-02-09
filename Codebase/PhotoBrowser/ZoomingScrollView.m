//
//  ZoomingScrollView.m
//  KTBook
//
//  Created by suger on 2018/1/23.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "ZoomingScrollView.h"

@interface ZoomingScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZoomingScrollView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [self initWithFrame:frame];
    if (self) {
        self.imageView.image = image;
        CGFloat ratio = image.size.width / image.size.height;
        CGRect bounds = self.imageView.bounds;
        bounds.size.height = bounds.size.width / ratio;
        self.imageView.bounds = bounds;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 0.5;
        self.maximumZoomScale = 2.0;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)zoomWithTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.imageView];
    [self zoomToRect:CGRectMake(point.x, point.y, 50, 50) animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.frame.size.width/2.0 , ycenter = scrollView.frame.size.height/2.0;
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2.0 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2.0 : ycenter;
    
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale < 1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
    }
}

@end
