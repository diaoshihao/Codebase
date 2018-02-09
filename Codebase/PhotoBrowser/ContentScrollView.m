//
//  ContentScrollView.m
//  KTBook
//
//  Created by suger on 2018/1/23.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "ContentScrollView.h"
#import "ZoomingScrollView.h"

@interface ContentScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;

@end

@implementation ContentScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (void)setupPhotos:(NSArray *)photos {
    if (photos.count == 0) {
        return;
    }
    self.photos = photos;
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            CGRect frame = self.bounds;
            frame.origin.x = idx * self.bounds.size.width;
            frame.size.width -= 10;
            ZoomingScrollView *zoomingView = [[ZoomingScrollView alloc] initWithFrame:frame image:obj];
            zoomingView.tag = 100 + idx;
            [self addSubview:zoomingView];
        }
    }];
    self.contentSize = CGSizeMake(self.bounds.size.width * self.photos.count, self.bounds.size.height);
    
    if ([self.contentDataSource respondsToSelector:@selector(firstIndexInContentView:)]) {
        NSUInteger index = [self.contentDataSource firstIndexInContentView:self];
        self.contentOffset = CGPointMake(index * self.bounds.size.width, 0);
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if ([self.contentDelegate respondsToSelector:@selector(contentViewDidScroll:toIndex:)]) {
        [self.contentDelegate contentViewDidScroll:self toIndex:index];
    }
}

- (void)shouldZoomingForIndex:(NSUInteger)index atPoint:(CGPoint)point {
    ZoomingScrollView *zoomingView = [self viewWithTag:(100 + index)];
    if (zoomingView.zoomScale > 1.0) {
        [zoomingView setZoomScale:1.0 animated:YES];
    } else {
        [zoomingView zoomToRect:CGRectMake(point.x, point.y, 50, 50) animated:YES];
    }
}

@end
