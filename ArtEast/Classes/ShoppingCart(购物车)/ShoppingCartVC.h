//
//  ShoppingCartVC.h
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  购物车
 *
 */

#import "BaseVC.h"

@interface ShoppingCartVC : BaseVC

@property (nonatomic , assign)BOOL isTabbarHidder;

- (void)updateDataForUI;

@end
