//
//  ShopCarModel.h
//  ArtEast
//
//  Created by yibao on 2016/12/27.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  购物车Model
 */

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject

@property (nonatomic , copy)NSString *thumbnail_url; //图标
@property (nonatomic , copy)NSString *name; //名称
@property (nonatomic , copy)NSString *spec_info; //规格
@property (nonatomic , copy)NSString *buy_price; //购买价格
@property (nonatomic , copy)NSString *price; //原价
@property (nonatomic , copy)NSString *quantity; //数量
@property (nonatomic , copy)NSString *goods_id; //货品id
@property (nonatomic , copy)NSString *store; //库存
@property (nonatomic , copy)NSString *ident; //标识 格式：goods_4688_6266
@property (nonatomic , copy)NSString *promotion; //促销
@property (nonatomic , copy)NSString *url; //商品详情url
@property (nonatomic , assign)BOOL isSelected; //是否选中

@end
