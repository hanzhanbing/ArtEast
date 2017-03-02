//
//  BestProjectView.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BestProjectView.h"
#import "AEImages.h"

@implementation BestProjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH-30, 15)];
        titleLab1.text = @"精选专题";
        titleLab1.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLab1];
        
        [self addSubview:self.projectCollectionView];
        
        UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, self.height-30, WIDTH-30, 15)];
        titleLab2.text = @"好物推荐";
        titleLab2.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLab2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, WIDTH, 0.3)];
        lineView.backgroundColor = LineColor;
        lineView.alpha = 0.6;
        [self addSubview:lineView];
    }
    return self;
}

#pragma mark - Getters

- (UICollectionView *)projectCollectionView {
    if (!_projectCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _projectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, WIDTH/2) collectionViewLayout:flowLayout];
        _projectCollectionView.delegate = self;
        _projectCollectionView.dataSource = self;
        _projectCollectionView.showsVerticalScrollIndicator = NO;
        _projectCollectionView.showsHorizontalScrollIndicator = NO;
        _projectCollectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
        [_projectCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCell"]; //主cell
    }
    return _projectCollectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//主cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCell" forIndexPath:indexPath];
    
    AEImages *images = self.dataSource[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-80, WIDTH/2)];
    imageView.backgroundColor = PageColor;
    [imageView sd_setImageWithURL:[NSURL URLWithString:images.ad_img]];
    [cell addSubview:imageView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH-80, WIDTH/2);
}

//点击cell事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AEImages *images = self.dataSource[indexPath.row];
    if (self.projectBlock) {
        self.projectBlock(images);
    }
}

@end
