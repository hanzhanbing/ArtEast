//
//  GoodsSkusModel.m
//  ArtEast
//
//  Created by yibao on 16/12/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsSkusModel.h"

@implementation GoodsSkusModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"iid",
             };
}

@end
