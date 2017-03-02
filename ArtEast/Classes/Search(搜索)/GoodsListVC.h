//
//  GoodsListVC.h
//  ArtEast
//
//  Created by yibao on 16/10/20.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品列表
 *
 */

#import "BaseVC.h"
#import "GoodsModel.h"

@interface GoodsListVC : BaseVC

@property (nonatomic,copy) NSString *virtual_cat_name;
@property (nonatomic,copy) NSString *virtual_cat_id;
@property (nonatomic,copy) NSString *search_content;

@end
