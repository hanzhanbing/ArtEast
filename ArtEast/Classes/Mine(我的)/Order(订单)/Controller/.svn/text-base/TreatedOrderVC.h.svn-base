//
//  TreatedOrderVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  已发货订单
 */

#import <UIKit/UIKit.h>
#import "OrderDelegate.h"

typedef void (^OrderViewBlock) (OrderModel *order);
typedef void (^OrderConfirmBlock) (OrderModel *order);
typedef void (^OrderDetailBlock) (OrderModel *order);

@interface TreatedOrderVC : UIViewController<OrderDelegate>

@property (nonatomic,copy) OrderViewBlock viewBlock; //查看物流
@property (nonatomic,copy) OrderConfirmBlock confirmBlock; //确认收货
@property (nonatomic,copy) OrderDetailBlock detailBlock; //跳转到订单详情

@property (nonatomic,retain) UITableView *tableView;

- (void)refresh;

@end
