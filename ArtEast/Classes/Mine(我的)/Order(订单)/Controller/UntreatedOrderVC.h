//
//  UntreatedOrderVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  待发货订单
 */

#import <UIKit/UIKit.h>
#import "OrderDelegate.h"

typedef void (^OrderDetailBlock) (OrderModel *order);

@interface UntreatedOrderVC : UIViewController<OrderDelegate>

@property (nonatomic,copy) OrderDetailBlock detailBlock; //跳转到订单详情

@property (nonatomic,retain) UITableView *tableView;

- (void)refresh;

@end
