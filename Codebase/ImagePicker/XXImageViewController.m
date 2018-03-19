//
//  XXImageViewController.m
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXImageViewController.h"
#import "XXImageManager.h"
#import "XXPreviewController.h"

typedef void(^CheckBlock)(BOOL isSelected);

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) XXAssetMediaType mediaType;

@property (nonatomic, copy) CheckBlock checkBlock;

@end

@implementation ImageCell
{
    UIButton *_selectedBtn;
    UIImageView *_mediaImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.frame = CGRectMake(self.bounds.size.width-30, 0, 30, 30);
        [_selectedBtn setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"checkbox_sel"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectedBtn];
        
        _mediaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, 30, 30)];
        _mediaImageView.image = [UIImage imageNamed:@"video_icon"];
        _mediaImageView.hidden = YES;
        [self.contentView addSubview:_mediaImageView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.bounds.size.height-30, self.bounds.size.width-30, 30)];
        self.timeLabel.hidden = YES;
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setMediaType:(XXAssetMediaType)mediaType {
    _mediaType = mediaType;
    self.timeLabel.hidden = mediaType != XXAssetMediaTypeVideo;
    _mediaImageView.hidden = self.timeLabel.hidden;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectedBtn.selected = isSelected;
}

- (void)checkClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.checkBlock) {
        self.checkBlock(sender.selected);
    }
}

@end

@interface XXImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XXPreviewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *assetsArray;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@end

@implementation XXImageViewController
{
    UIButton *_sureBtn;
    UILabel *_countLabel;
}


- (NSMutableArray *)selectedAssets {
    if (_selectedAssets == nil) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarItem]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    [[XXImageManager shareManager] getAssetsFromModel:self.model compeletion:^(NSArray<XXAssetModel *> *models) {
        self.assetsArray = models;
        [self.collectionView reloadData];
        
        if (self.assetsArray.count > 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assetsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadClearForVisible];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadClearForVisible];
}

- (void)loadClearForVisible {
    [[self.collectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XXAssetModel *model = self.assetsArray[obj.item];
        if (model.isDegraded) {
            [[XXImageManager shareManager] requestHighQualityImageWithAsset:model.asset completeHandle:^(UIImage *image) {
                model.image = image;
                model.isDegraded = NO;
                [self.collectionView reloadItemsAtIndexPaths:@[obj]];
            }];
        }
    }];
}

- (UIView *)rightBarItem {
    UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    _countLabel.text = @"0";
    _countLabel.layer.cornerRadius = 10;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor colorWithRed:0 green:195/225.0 blue:69/225.0 alpha:1];
    [item addSubview:_countLabel];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(40, 0, 40, 44);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithRed:0 green:195/225.0 blue:69/225.0 alpha:1] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.enabled = NO;
    [item addSubview:_sureBtn];
    
    return item;
}

- (void)selectedAssetsDidChange {
    _sureBtn.enabled = self.selectedAssets != 0;
    _countLabel.text = [NSString stringWithFormat:@"%ld",self.selectedAssets.count];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [_countLabel.layer addAnimation:animation forKey:nil];
}

- (void)sureClick {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImagePickerNotification" object:self.selectedAssets];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - 25) / 4.0;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XXAssetModel *model = self.assetsArray[indexPath.item];
    cell.imageView.image = model.image;
    cell.isSelected = model.isSelected;
    cell.timeLabel.text = model.videoDuration;
    cell.mediaType = model.mediaType;
    
    __weak typeof(self) weakSelf = self;
    cell.checkBlock = ^(BOOL isSelected) {
        model.isSelected = isSelected;
        isSelected ? [weakSelf didSelectAsset:model atIndex:indexPath.item] : [weakSelf didDeselectAsset:model atIndex:indexPath.item];
    };
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XXPreviewController *VC = [[XXPreviewController alloc] initWithAssets:self.assetsArray atIndex:indexPath.row];
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didSelectAsset:(XXAssetModel *)asset atIndex:(NSInteger)index {
    if (index < self.assetsArray.count) {
        [self.selectedAssets addObject:asset];
        
        [self selectedAssetsDidChange];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }
}

- (void)didDeselectAsset:(XXAssetModel *)asset atIndex:(NSInteger)index {
    if (index < self.assetsArray.count) {
        [self.selectedAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXAssetModel *model = obj;
            if (model == asset) {
                [self.selectedAssets removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        
        [self selectedAssetsDidChange];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }
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
