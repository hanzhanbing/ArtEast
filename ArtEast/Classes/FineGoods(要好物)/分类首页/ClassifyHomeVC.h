//
//  ClassifyHomeVC.h
//  ArtEast
//
//  Created by yibao on 2017/2/16.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  分类首页
 *
 */

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@class AEImages;
typedef void (^GoodsDetailBlock) (GoodsModel *goodsModel);
typedef void (^ImageRollBlock) (AEImages *images);
typedef void (^WebBlock) (NSString *webUrl);

@interface ClassifyHomeVC : UIViewController

@property (nonatomic,copy) GoodsDetailBlock detailBlock;
@property (nonatomic,copy) dispatch_block_t loginBlock; //跳登录
@property (nonatomic,copy) ImageRollBlock imageRollBlock; //图片轮播跳转(跳商品列表、商品详情、网页)
@property (nonatomic,copy) WebBlock webBlock; //跳网页
@property (nonatomic,copy) dispatch_block_t welfareBlock; //跳福利中心

@property (nonatomic,retain) NSString *index;

@property (nonatomic,strong) UICollectionView *mainCollectionView;

@end
