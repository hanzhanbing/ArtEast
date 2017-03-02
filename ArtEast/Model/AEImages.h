//
//  AEImages.h
//  ArtEast
//
//  Created by yibao on 16/11/29.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  发现图片Modle
 *
 */

#import "AEInfo.h"

@interface AEImages : AEInfo

@property (nonatomic,copy) NSString *ad_img; //轮播图图片
@property (nonatomic,copy) NSString *ad_url; //链接地址
@property (nonatomic,copy) NSDictionary *app; //原生参数Dic
@property (nonatomic,copy) NSString *ca_name; //分类名称
@property (nonatomic,copy) NSString *url_type; //链接类型
@property (nonatomic,copy) NSString *desc; //分享描述

@end
