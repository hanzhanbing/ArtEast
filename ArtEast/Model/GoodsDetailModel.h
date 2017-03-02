//
//  GoodsDetailModel.h
//  ArtEast
//
//  Created by yibao on 16/12/8.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品详情Model
 */

#import <Foundation/Foundation.h>
#import "GoodsSkusModel.h"
#import "GoodsSpecInfoModel.h"

@interface GoodsDetailModel : NSObject

@property (nonatomic,copy) NSString *ID;    //ID
@property (nonatomic,copy) NSString *title;  //名称
@property (nonatomic,copy) NSString *brief; //简介
@property (nonatomic,copy) NSString *pictureDetail; //图文详情div
@property (nonatomic,copy) NSString *favs_count; //喜欢数量
@property (nonatomic,copy) NSString *comments_count; //评论数量
@property (nonatomic,copy) NSString *store; //库存
@property (nonatomic,copy) NSString *freez; //冻结
@property (nonatomic,copy) NSString *realStore; //真实库存（实际库存-冻结库存）
@property (nonatomic,copy) NSString *price; //价格
@property (nonatomic,copy) NSString *market_price; //市场价格
@property (nonatomic,copy) NSString *unit; //单位
@property (nonatomic,copy) NSString *buy_limit; //购买限制
@property (nonatomic,copy) NSString *marketable; //是否上架、下架
@property (nonatomic,copy) NSString *select_count; //已选数量
@property (nonatomic,copy) NSString *select_skus; //已选规格
@property (nonatomic,copy) NSString *select_skusID; //已选规格ID
@property (nonatomic,assign) int select_skusIndex; //已选规格索引
@property (nonatomic,retain) NSArray *select_skusImgs; //已选规格图片数组

@property (nonatomic,retain) NSArray *des_imgs; //图文详情图片数组
@property (nonatomic,retain) NSArray *item_imgs; //图片轮播图片数组
@property (nonatomic,retain) NSArray *skus; //规格数组
@property (nonatomic,retain) NSArray *spec_info; //属性信息数组

@property (nonatomic,retain) NSDictionary *promotion; //促销信息

@end
