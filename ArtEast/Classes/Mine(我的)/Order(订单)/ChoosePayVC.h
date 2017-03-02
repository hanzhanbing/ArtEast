//
//  ChoosePayVC.h
//  ArtEast
//
//  Created by yibao on 16/11/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  选择支付方式
 *
 */

#import "BaseVC.h"
#import "OrderModel.h"

@interface ChoosePayVC : BaseVC

@property (nonatomic,retain) OrderModel *order;
@property (nonatomic,copy) NSString *fromFlag;

@end
