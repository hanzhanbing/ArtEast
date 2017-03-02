//
//  OrderModel.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  订单Model
 */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UnPayOrderType,
    UntreatedOrderType,
    TreatedOrderType,
    UnCommentOrderType,
    DestroyOrderType,
    CompletedOrderType,
    RefundOrderType,
} OrderType;

@interface OrderModel : NSObject

@property (nonatomic,copy) NSString *createtime; //订单时间
@property (nonatomic,copy) NSString *ID; //订单ID
@property (nonatomic,copy) NSString *pay_status; //付款状态
@property (nonatomic,copy) NSString *ship_status; //发货状态
@property (nonatomic,copy) NSString *status; //订单状态
@property (nonatomic,retain) NSMutableArray *goodsArr; //商品数组
@property (nonatomic,copy) NSString *total_amount; //付款金额
@property (nonatomic,assign) int type; //订单类型
@property (nonatomic,copy) NSString *order_status; //订单类型
@property (nonatomic,copy) NSString *itemnum; //商品数量
@property (nonatomic,copy) NSString *name; //商品名称
@property (nonatomic,copy) NSString *thumbnail_pic_src; //商品图片
@property (nonatomic,copy) NSString *spec_info; //商品规格
@property (nonatomic,copy) NSString *url; //商品详情链接地址
@property (nonatomic,copy) NSString *goods_id; //货品ID
@property (nonatomic,copy) NSString *product_id; //商品ID

@end
