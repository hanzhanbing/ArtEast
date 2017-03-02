//
//  AllOrderVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  全部订单
 *
 */

#import <UIKit/UIKit.h>
#import "OrderDelegate.h"

typedef void (^OrderPayBlock) (OrderModel *order);
typedef void (^OrderCancelBlock) (NSString *orderId);
typedef void (^OrderViewBlock) (OrderModel *order);
typedef void (^OrderConfirmBlock) (OrderModel *order);
typedef void (^OrderDetailBlock) (OrderModel *order);

@interface AllOrderVC : UIViewController<OrderDelegate>

@property (nonatomic,copy) OrderPayBlock payBlock; //付款
@property (nonatomic,copy) OrderCancelBlock cancelBlock; //取消订单
@property (nonatomic,copy) OrderViewBlock viewBlock; //查看物流
@property (nonatomic,copy) OrderConfirmBlock confirmBlock; //确认收货
@property (nonatomic,copy) OrderDetailBlock detailBlock; //跳转到订单详情

@property (nonatomic,retain) UITableView *tableView;

- (void)refresh;

@end
