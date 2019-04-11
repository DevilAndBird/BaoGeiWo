//
//  WQPhotoBrowser.m
//  BaoGeiWo
//
//  Created by wb on 2018/8/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "WQPhotoBrowser.h"
#import "WQPhotoCell.h"

@interface WQPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WQPhotoBrowser

- (instancetype)initWithPhotos:(NSArray *)photos atIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.photos = [NSMutableArray arrayWithArray:photos];
        self.currentIndex = index;
    }
    return self;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)deleteImage {
    NSString *imageUrl = self.photos[self.currentIndex];
    [self.photos removeObject:imageUrl];
    if (self.deleteImageBlock) {
        self.deleteImageBlock(imageUrl);
    }
    if (self.photos.count == 0) {
        [self back];
        return;
    }
    
    if (self.currentIndex+1 > self.photos.count) {
        --self.currentIndex;
    }
    
    [self.collectionView reloadData];
//    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentIndex inSection:0]]];
    self.navTitleLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.currentIndex+1, self.photos.count];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *navView = [[UIView alloc] init];
//    navView.backgroundColor = RGBA(0, 0, 0, .4f);
    navView.backgroundColor = kBlackColor;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(KNavBarHeight));
    }];
    UIButton *backBtn = [[UIButton alloc] init];
//    [back setTitle:@"back" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@44);
    }];
    
    UILabel *navTitle = [[UILabel alloc] initWithTextColor:kWhiteColor font:BGWFont(16)];
    [navView addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(backBtn);
    }];
    self.navTitleLabel = navTitle;
    
    if (self.deleteButtonShow) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(@0);
            make.width.equalTo(@60);
            make.height.equalTo(@44);
        }];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.bgw_w+20, self.view.bgw_h);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.scrollsToTop = NO;
    collectionView.contentSize = CGSizeMake((self.view.bgw_w+20)*self.photos.count, 0);
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom);
        make.left.mas_equalTo(-10);
        make.right.mas_equalTo(10);
        make.bottom.equalTo(@0);
    }];
    [collectionView registerClass:[WQPhotoCell class] forCellWithReuseIdentifier:@"WQPhotoCell"];
    [collectionView setContentOffset:CGPointMake((self.view.bgw_w+20)*_currentIndex, 0)];
    self.collectionView = collectionView;
    
    self.navTitleLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.currentIndex+1, self.photos.count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WQPhotoCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[indexPath.row]]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.bgw_w + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.bgw_w + 20);
    
    if (currentIndex < self.photos.count && self.currentIndex != currentIndex) {
        self.currentIndex = currentIndex;
        self.navTitleLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.currentIndex+1, self.photos.count];
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
