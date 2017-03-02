//
//  GoodsSpecModel.h
//  ArtEast
//
//  Created by yibao on 16/12/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品品牌Model
 */

#import <Foundation/Foundation.h>

@interface GoodsSpecModel : NSObject

@property (nonatomic,copy) NSString *private_spec_value_id; //私有品牌id
@property (nonatomic,copy) NSString *spec_value_id;  //品牌id
@property (nonatomic,copy) NSString *spec_value; //品牌名称
@property (nonatomic,copy) NSString *properties; //品牌属性
@property (nonatomic,copy) NSString *spec_goods_images;
@property (nonatomic,copy) NSString *spec_image; //品牌图片

@end
