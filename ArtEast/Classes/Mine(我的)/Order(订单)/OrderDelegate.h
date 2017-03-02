//
//  OrderDelegate.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  订单代理
 *
 */

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@protocol OrderDelegate <NSObject>

@optional

/**
 *  付款
 *
 *  @param order 订单model
 */
- (void)clickPayOrder:(OrderModel *)order;

/**
 *  取消订单
 *
 *  @param orderId 订单id
 */
- (void)clickCancelOrder:(NSString *)orderId;

/**
 *  查看物流
 *
 *  @param order 订单model
 */
- (void)clickViewOrder:(OrderModel *)order;

/**
 *  确认收货
 *
 *  @param order 订单model
 */
- (void)clickConfirmOrder:(OrderModel *)order;

/**
 *  去评价
 *
 *  @param order 订单model
 */
- (void)clickCommentOrder:(OrderModel *)order;

@end
