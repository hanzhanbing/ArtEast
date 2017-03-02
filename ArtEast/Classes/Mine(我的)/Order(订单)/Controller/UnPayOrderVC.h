//
//  UnPayOrderVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  待付款订单
 */

#import <UIKit/UIKit.h>
#import "OrderDelegate.h"

typedef void (^OrderCancelBlock) (NSString *orderId);
typedef void (^OrderDetailBlock) (OrderModel *order);
typedef void (^OrderPayBlock) (OrderModel *order);

@interface UnPayOrderVC : UIViewController<OrderDelegate>

@property (nonatomic,copy) OrderCancelBlock cancelBlock; //取消订单
@property (nonatomic,copy) OrderDetailBlock detailBlock; //跳转到订单详情
@property (nonatomic,copy) OrderPayBlock payBlock; //付款

@property (nonatomic,retain) UITableView *tableView;

- (void)refresh;

@end
