//
//  UnCommentOrderVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  待评价订单
 */

#import <UIKit/UIKit.h>
#import "OrderDelegate.h"
#import "GoodsModel.h"

typedef void (^OrderCommentBlock) (OrderModel *order);
typedef void (^GoodsDetailBlock) (GoodsModel *goodsModel);

@interface UnCommentOrderVC : UIViewController<OrderDelegate>

@property (nonatomic,copy) OrderCommentBlock commentBlock; //去评价
@property (nonatomic,copy) GoodsDetailBlock detailBlock; //跳转到商品详情

@property (nonatomic,retain) UITableView *tableView;

- (void)refresh;

@end
