//
//  ClassifySubListVC.h
//  ArtEast
//
//  Created by yibao on 2017/2/19.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseVC.h"
@class AESubTypeInfo;
@class GoodsModel;

typedef void (^GoodsDetailBlock) (GoodsModel *goodsModel);

@interface ClassifySubListVC : UIViewController

@property (nonatomic,copy) GoodsDetailBlock detailBlock; //商品详情
@property (nonatomic,copy) dispatch_block_t loginBlock; //跳登录

@property (nonatomic,retain) AESubTypeInfo *typeInfo;
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic,assign) BOOL isGrid;

@property (nonatomic,retain) NSString *index;

-(void)changeCollectState:(NSDictionary *)dic;

@end
