//
//  SHImageView.m
//  Codebase
//
//  Created by suger on 2018/2/9.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "SHImageView.h"
#import "SHImageManager.h"

@interface SHImageView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) SHImageManager *imageManager;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) CGSize size;

@end

@implementation SHImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupImageView];
        self.imageManager = [SHImageManager shareManager];
    }
    return self;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    self.imageView.center = self.center;
    
    [self renderLoadingImage];
    [self requestImage];
}

//正在加载
- (void)renderLoadingImage {
    self.imageView.image = [UIImage imageNamed:@"loading"];
}

- (void)requestImage {
    [self.imageManager requestImageWithUrl:self.url size:self.size complete:^(UIImage *image, NSError *error) {
        if (error) {
            
        } else {
            self.imageView.image = image;
        }
    }];
}


- (void)imageWithUrl:(NSString *)url size:(CGSize)size {
    if (!([self.url isEqualToString:url] && CGSizeEqualToSize(self.size, size))) {
        self.url = url;
        self.size = size;
        [self setNeedsLayout];
    }
}

@end


