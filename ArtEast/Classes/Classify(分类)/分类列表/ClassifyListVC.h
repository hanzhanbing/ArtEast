//
//  ClassifyListVC.h
//  ArtEast
//
//  Created by yibao on 2017/2/19.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品分类列表
 *
 */

#import "BaseVC.h"

@interface ClassifyListVC : BaseVC

@property (nonatomic,assign) int currentPage;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) NSMutableArray *subArr;

@end
