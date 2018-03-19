//
//  XXPreviewController.m
//  NBPicker
//
//  Created by suger on 2018/3/14.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXPreviewController.h"
#import "XXImageManager.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^SingleTapBlock)(void);

@interface XXPhotoPreviewCell : UICollectionViewCell <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) SingleTapBlock singleTapBlock;

@end

@implementation XXPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale = 3.0;
        self.scrollView.minimumZoomScale = 0.6;
        self.scrollView.contentSize = self.bounds.size;
        self.scrollView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.imageView];
        
        [self addGestureToImageView];
        [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


#pragma mark - gestures

- (void)addGestureToImageView {
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint point = [tap locationInView:self.imageView];
        CGFloat scale = self.scrollView.maximumZoomScale;
        CGFloat width = self.imageView.bounds.size.width / scale;
        CGFloat height = self.imageView.bounds.size.height / scale;
        [self.scrollView zoomToRect:CGRectMake(point.x - width/2.0, point.y - height/2.0, width, height) animated:YES];
    }
}


#pragma mark - imageDidChange

//根据image设置iamgeView大小
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *image = change[NSKeyValueChangeNewKey];
        if (image) {
            CGFloat imageRatio = image.size.width / image.size.height;
            CGRect bounds = self.imageView.bounds;
            bounds.size.height = bounds.size.width/imageRatio;
            self.imageView.bounds = bounds;
        }
    }
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
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

@interface XXVideoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, copy) SingleTapBlock singleTapBlock;

@end

@implementation XXVideoPreviewCell
{
    UIImageView *_playImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = [[AVPlayer alloc] init];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = self.bounds;
        [self.contentView.layer addSublayer:layer];
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _playImageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        _playImageView.image = [UIImage imageNamed:@"video_play"];
        _playImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _playImageView.layer.cornerRadius = 40;
        _playImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _playImageView.layer.borderWidth = 2;
        _playImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_playImageView];
        
        [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.contentView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        _playImageView.hidden = self.player.rate != 0;
    }
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"rate"];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    self.player.rate == 0 ? [self.player play] : [self.player pause];
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

@end

@interface XXPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *assetsArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation XXPreviewController

- (instancetype)initWithAssets:(NSArray *)assets atIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.assetsArray = assets;
        self.currentIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, size.width+20, size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[XXPhotoPreviewCell class] forCellWithReuseIdentifier:@"photo"];
    [self.collectionView registerClass:[XXVideoPreviewCell class] forCellWithReuseIdentifier:@"video"];
    [self.view addSubview:self.collectionView];
    
    if (self.currentIndex < self.assetsArray.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.selectBtn setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"checkbox_sel"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(handleSelection:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    
    self.selectBtn.selected = [self isSelectedAtCurrentIndex];
}

- (void)handleSelection:(UIButton *)sender {
    
    if (self.currentIndex < self.assetsArray.count) {
        sender.selected = !sender.selected;
        
        XXAssetModel *model = self.assetsArray[self.currentIndex];
        model.isSelected = sender.selected;
        if (model.isSelected && [self.delegate respondsToSelector:@selector(didSelectAsset:atIndex:)]) {
            [self.delegate didSelectAsset:model atIndex:self.currentIndex];
        } else if (!model.isSelected && [self.delegate respondsToSelector:@selector(didDeselectAsset:atIndex:)]) {
            [self.delegate didDeselectAsset:model atIndex:self.currentIndex];
        }
    } else {
        NSLog(@"无法选择");
    }
}

- (BOOL)isSelectedAtCurrentIndex {
    if (self.currentIndex < self.assetsArray.count) {
        XXAssetModel *model = self.assetsArray[self.currentIndex];
        return model.isSelected;
    } else {
        return NO;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XXAssetModel *model = self.assetsArray[indexPath.item];
    if (model.mediaType == XXAssetMediaTypePhoto) {
        XXPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
        return cell;
    } else {
        XXVideoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    if ([cell isKindOfClass:[XXPhotoPreviewCell class]]) {
        XXPhotoPreviewCell *precell = (XXPhotoPreviewCell *)cell;
        XXAssetModel *model = self.assetsArray[indexPath.item];
        precell.imageView.image = model.image;
        if (model.isDegraded) {
            [[XXImageManager shareManager] requestHighQualityImageWithAsset:model.asset completeHandle:^(UIImage *image) {
                precell.imageView.image = image;
                model.isDegraded = NO;
                model.image = image;
            }];
        }
        
        precell.singleTapBlock = ^{
            BOOL isHidden = weakSelf.navigationController.navigationBarHidden;
            [weakSelf.navigationController setNavigationBarHidden:!isHidden animated:YES];
        };
    } else {
        XXVideoPreviewCell *precell = (XXVideoPreviewCell *)cell;
        XXAssetModel *model = self.assetsArray[indexPath.item];
        [[XXImageManager shareManager] requestVideoWithAsset:model.asset completeHandle:^(AVPlayerItem *playerItem) {
            [precell.player replaceCurrentItemWithPlayerItem:playerItem];
        }];
        
        precell.singleTapBlock = ^{
            BOOL isHidden = precell.player.rate == 0;
            [weakSelf.navigationController setNavigationBarHidden:!isHidden animated:YES];
        };
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width-20, collectionView.bounds.size.height);
}

//滑动时停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    if ([cell isKindOfClass:[XXVideoPreviewCell class]]) {
        XXVideoPreviewCell *precell = (XXVideoPreviewCell *)cell;
        [precell.player seekToTime:kCMTimeZero];
        [precell.player pause];
    }
}

//确定当前下标
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSInteger firstItem = [self.collectionView indexPathsForVisibleItems].firstObject.item;
    NSInteger lastItem = [self.collectionView indexPathsForVisibleItems].lastObject.item;
    self.currentIndex = firstItem <= lastItem ? firstItem : lastItem;
    
    self.selectBtn.selected = [self isSelectedAtCurrentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
