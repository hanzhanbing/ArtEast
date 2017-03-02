//
//  GoodsCommentModel.h
//  ArtEast
//
//  Created by yibao on 16/12/9.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品评论Model
 */

#import <Foundation/Foundation.h>

@interface GoodsCommentModel : NSObject

@property (nonatomic,copy) NSString *author;    //账号
@property (nonatomic,copy) NSString *comment;  //评论
@property (nonatomic,copy) NSString *time; //时间
@property (nonatomic,copy) NSString *url; //头像地址
@property (nonatomic,copy) NSString *spec_info; //规格信息

@property (nonatomic,retain) NSArray *images; //图片数组

@end
