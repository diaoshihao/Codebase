//
//  XXImagePickerController.m
//  NBPicker
//
//  Created by suger on 2018/3/13.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXImagePickerController.h"
#import "XXAlbumViewController.h"
#import "XXImageViewController.h"


@interface XXImagePickerController ()

@property (nonatomic, strong) XXAlbumViewController *albumVC;

@property (nonatomic, strong) XXImageViewController *imageVC;

@end

@implementation XXImagePickerController

- (XXAlbumViewController *)albumVC {
    if (_albumVC == nil) {
        _albumVC = [[XXAlbumViewController alloc] init];
    }
    return _albumVC;
}

- (instancetype)initWithConfig:(XXPickerConfig *)config delegate:(id<XXImagePickerDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.pickerDelegate = delegate;
        self.config = config ? config : [XXPickerConfig defaultConfig];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.config = [XXPickerConfig defaultConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = @[self.albumVC];
    self.albumVC.albumTypes = self.config.albumTypes;
    self.albumVC.autoAlbumType = self.config.autoAlbumType;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePickerNotification:) name:@"ImagePickerNotification" object:nil];
}

- (void)imagePickerNotification:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[NSArray class]]) {
        NSArray<XXAssetModel *> *allAssets = noti.object;
        NSMutableArray *allImages = [[NSMutableArray alloc] init];
        NSMutableArray *photosAssets = [[NSMutableArray alloc] init];
        NSMutableArray *videosAssets = [[NSMutableArray alloc] init];
        NSMutableArray *photosImages = [[NSMutableArray alloc] init];
        NSMutableArray *videosCovers = [[NSMutableArray alloc] init];
        
        [allAssets enumerateObjectsUsingBlock:^(XXAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XXAssetModel class]]) {
                XXAssetModel *model = obj;
                [allImages addObject:model.image];
                
                if (model.mediaType == XXAssetMediaTypePhoto) {
                    [photosAssets addObject:model];
                    [photosImages addObject:model.image];
                    
                } else if (model.mediaType == XXAssetMediaTypeVideo) {
                    [videosAssets addObject:model];
                    [videosCovers addObject:model.image];
                }
            }
        }];
        
        if ([self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMedia:)]) {
            [self.pickerDelegate imagePickerController:self didFinishPickingMedia:allAssets];
        }
        
        if ([self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickedPhotos:assets:)]) {
            [self.pickerDelegate imagePickerController:self didFinishPickedPhotos:photosImages assets:photosAssets];
        }
        
        if ([self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickedVideos:assets:)]) {
            [self.pickerDelegate imagePickerController:self didFinishPickedVideos:videosCovers assets:videosAssets];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
