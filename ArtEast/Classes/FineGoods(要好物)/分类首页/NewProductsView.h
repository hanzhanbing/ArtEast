//
//  NewProductsView.h
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  人气新品
 *
 */

#import <UIKit/UIKit.h>
@class GoodsModel;

typedef void (^GoodsDetailBlock) (GoodsModel *goodsModel);

@interface NewProductsView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy) GoodsDetailBlock detailBlock; //商品详情
@property (nonatomic,strong) UICollectionView *productsCollectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
