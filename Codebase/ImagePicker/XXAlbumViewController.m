//
//  XXAlbumViewController.m
//  NBPicker
//
//  Created by suger on 2018/3/12.
//  Copyright © 2018年 diaoshihao. All rights reserved.
//

#import "XXAlbumViewController.h"
#import "XXImageManager.h"
#import "XXImageViewController.h"

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.separatorInset = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupViews {
    self.coverImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.coverImgView];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    
    self.countLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.countLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverImgView.frame = CGRectMake(10, 10, self.bounds.size.height-20, self.bounds.size.height-20);
    self.nameLabel.frame = CGRectMake(self.bounds.size.height, 20, self.bounds.size.width-self.bounds.size.height, 30);
    self.countLabel.frame = CGRectMake(self.bounds.size.height, 60, self.bounds.size.width-self.bounds.size.height, 30);
}

@end

@interface XXAlbumViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation XXAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的相册";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[XXImageManager shareManager] getAlbumsWithXXAlbumTypes:self.albumTypes compeletion:^(NSArray<XXAlbumModel *> *models) {
        self.dataArr = models;
        [self.tableView reloadData];
    }];
    
    if (self.autoAlbumType != XXAutoAlbumTypeNone) {
        [self showAutoAlbum];
    }
}

- (void)showAutoAlbum {
    if (self.albumTypes == XXAlbumTypeOptionsAny || self.albumTypes & self.autoAlbumType) {
        if (self.autoAlbumType == XXAutoAlbumTypeRecentlyAdded) {
            [self showAlbumByEn_name:@"RecentlyAdded" cn_name:@"最近添加"];
        } else if (self.autoAlbumType == XXAutoAlbumTypeUserLibrary) {
            [self showAlbumByEn_name:@"UserLibrary" cn_name:@"相机胶卷"];
        } else if (self.autoAlbumType == XXAutoAlbumTypeVideos) {
            [self showAlbumByEn_name:@"Videos" cn_name:@"视频"];
        }
    }
}

- (void)showAlbumByEn_name:(NSString *)en_name cn_name:(NSString *)cn_name {
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XXAlbumModel *model = obj;
        if ([model.name isEqualToString:en_name] || [model.name isEqualToString:cn_name]) {
            [self showPhotosWithAlbumModel:model animated:NO];
            *stop = YES;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
}

- (void)cancelAction:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    XXAlbumModel *model = self.dataArr[indexPath.section];
    cell.nameLabel.text = model.name;
    cell.countLabel.text = model.imgCount;
    cell.coverImgView.image = model.coverImg == nil ? [UIImage imageNamed:@"photo_placeholder"] : model.coverImg;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXAlbumModel *model = self.dataArr[indexPath.section];

    [self showPhotosWithAlbumModel:model animated:YES];
}

- (void)showPhotosWithAlbumModel:(XXAlbumModel *)model animated:(BOOL)animated {
    XXImageViewController *VC = [[XXImageViewController alloc] init];
    VC.model = model;
    [self.navigationController pushViewController:VC animated:animated];
    
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
