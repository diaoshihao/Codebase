//
//  SHPhotoBrowser.m
//  KTBook
//
//  Created by suger on 2018/1/23.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "SHPhotoBrowser.h"
#import "ContentScrollView.h"

@interface SHPhotoBrowser() <ContentScrollViewDelegate,ContentScrollViewDataSource>

@property (nonatomic, strong) ContentScrollView *contentScrollView;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation SHPhotoBrowser

#pragma mark - initializer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSelf];
    [self initialContentView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)initialSelf {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressaAction:)];
    
    singleTap.numberOfTapsRequired = 1;
    doubleTap.numberOfTapsRequired = 2;
    longPress.minimumPressDuration = 0.5;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:doubleTap];
    [self.view addGestureRecognizer:longPress];
}

- (void)initialContentView {
    CGRect frame = self.view.bounds;
    frame.size.width += 10;
    self.contentScrollView = [[ContentScrollView alloc] initWithFrame:frame];
    self.contentScrollView.contentDelegate = self;
    self.contentScrollView.contentDataSource = self;
    [self.contentScrollView setupPhotos:self.photos];
    [self.view addSubview:self.contentScrollView];
}

- (NSUInteger)firstIndexInContentView:(ContentScrollView *)contentView {
    return self.currentIndex;
}

- (NSUInteger)numberOfImagesInContentView:(ContentScrollView *)contentView {
    return self.photos.count;
}

- (UIImage *)contentView:(ContentScrollView *)contentView imageForIndex:(NSUInteger)index {
    return self.photos[index];
}

- (void)contentViewDidScroll:(ContentScrollView *)contentView toIndex:(NSUInteger)index {
    self.currentIndex = index;
}

#pragma mark - public method

+ (instancetype)browserWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index {
    if (index >= photos.count) {
        index = 0;
    }
    SHPhotoBrowser *browser = [[SHPhotoBrowser alloc] initWithPhotos:photos currentIndex:index];
    [browser show];
    return browser;
}

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index {
    if (index >= photos.count) {
        index = 0;
    }
    self = [super init];
    if (self) {
        self.photos = photos;
        self.currentIndex = index;
    }
    return self;
}

#pragma mark - private method

- (void)show {
    [self.contentScrollView setupPhotos:self.photos];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:NO completion:nil];
}

- (void)dismiss {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    [self.contentScrollView shouldZoomingForIndex:self.currentIndex atPoint:[tap locationInView:self.view]];
}

- (void)longPressaAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self presentAlertSheet];
    }
}

- (void)presentAlertSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"图片操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImageToAlbum];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveImageToAlbum {
    if (self.currentIndex >= self.photos.count || ![self.photos[self.currentIndex] isKindOfClass:[UIImage class]]) {
        [self showText:@"保存失败"];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(self.photos[self.currentIndex], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self showText:@"保存失败"];
    } else {
        [self showText:@"已保存到相册"];
    }
}

@end
