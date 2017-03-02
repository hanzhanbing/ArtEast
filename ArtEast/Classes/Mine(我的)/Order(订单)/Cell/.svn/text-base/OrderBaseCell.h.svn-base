//
//  OrderBaseCell.h
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/18.
//  Copyright © 2016年 柯南. All rights reserved.
//

/**
 *  订单基类cell
 */

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "OrderModel.h"
#import "OrderDelegate.h"

@interface OrderBaseCell : UITableViewCell

@property (nonatomic,assign) id<OrderDelegate> delegate;

@property (nonatomic,retain) UIImageView *goodsImg; //商品图片
@property (nonatomic,retain) UIButton *confirmBtn; //确认收货

- (void)addContentView;
- (void)setContentView:(OrderModel *)orderModel;

+ (NSString *)getIdentifier;
+ (CGFloat)getHeight:(OrderModel *)orderModel;

@end
