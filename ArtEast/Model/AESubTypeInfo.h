//
//  AESubTypeInfo.h
//  ArtEast
//
//  Created by yibao on 16/10/18.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESubTypeInfo : NSObject

@property (nonatomic,copy) NSString *virtual_cat_id; //子分类id
@property (nonatomic,copy) NSString *virtual_cat_name; //子分类名称
@property (nonatomic,copy) NSString *filter;
@property (nonatomic,copy) NSString *parent_id; //父分类id
@property (nonatomic,copy) NSString *child_count; //子分类数量
@property (nonatomic,copy) NSString *url; //跳转地址
@property (nonatomic,copy) NSString *picture; //子分类图片

@end
