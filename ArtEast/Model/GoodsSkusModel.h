//
//  GoodsSkusModel.h
//  ArtEast
//
//  Created by yibao on 16/12/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品规格Model
 */

#import <Foundation/Foundation.h>

@interface GoodsSkusModel : NSObject

@property (nonatomic,copy) NSString *ID;    //ID
@property (nonatomic,copy) NSString *freez;  //是否冻结
@property (nonatomic,copy) NSString *is_default; //是否默认选中
@property (nonatomic,copy) NSString *market_price; //市场价
@property (nonatomic,copy) NSString *marketable; //是否上架
@property (nonatomic,copy) NSString *price; //价格
@property (nonatomic,copy) NSString *properties; //属性
@property (nonatomic,copy) NSString *sku_id; //规格id
@property (nonatomic,copy) NSArray *spec_goods_images; //规格图片数组
@property (nonatomic,copy) NSString *store; //库存

@end
