//
//  NewProductsView.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NewProductsView.h"
#import "GoodsModel.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"

@implementation NewProductsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH-30, 15)];
        titleLab.text = @"人气新品";
        titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLab];
        
        [self addSubview:self.productsCollectionView];
        
        UIView *grayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-10, WIDTH, 10)];
        grayBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
        [self addSubview:grayBgView];
    }
    return self;
}

#pragma mark - Getters

- (UICollectionView *)productsCollectionView {
    if (!_productsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _productsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, WIDTH/2.8 + 60) collectionViewLayout:flowLayout];
        _productsCollectionView.delegate = self;
        _productsCollectionView.dataSource = self;
        _productsCollectionView.showsVerticalScrollIndicator = NO;
        _productsCollectionView.showsHorizontalScrollIndicator = NO;
        _productsCollectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
        [_productsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ProductItemCell"]; //主cell
    }
    return _productsCollectionView;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    //防止cell复用带来的控件重叠
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    GoodsModel *model = self.dataSource[indexPath.row];
    
    UIView *goodsView;
    if (indexPath.row==self.dataSource.count-1){
        goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2.7+10, WIDTH/2.7 + 60)];
        [cell.contentView addSubview:goodsView];
    } else {
        goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2.7, WIDTH/2.7 + 60)];
        [cell.contentView addSubview:goodsView];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2.7, WIDTH/2.7)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = PageColor;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    [goodsView addSubview:imageView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.maxY+15, imageView.width, 20)];
    titleLabel.text = model.name;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [goodsView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.maxY+5, imageView.width, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    priceLabel.textColor = PriceColor;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [goodsView addSubview:priceLabel];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.dataSource.count-1) {
        return CGSizeMake(WIDTH/2.7+10, WIDTH/2.7 + 60);
    } else {
        return CGSizeMake(WIDTH/2.7, WIDTH/2.7 + 60);
    }
}

//点击cell事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsModel *goodsModel = self.dataSource[indexPath.row];
    
    if (self.detailBlock) {
        return self.detailBlock(goodsModel);
    }
}

@end
