//
//  GoodsDetailModel.m
//  ArtEast
//
//  Created by yibao on 16/12/8.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"iid",
             @"pictureDetail":@"description",
             };
}

+(NSDictionary *)objectClassInArray
{
    return @{@"skus":[GoodsSkusModel class],
             @"spec_info":[GoodsSpecInfoModel class],
             };
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

@end
