//
//  GoodsFavModel.h
//  ArtEast
//
//  Created by yibao on 2017/2/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsFavModel : NSObject

@property (nonatomic,copy) NSString *avatar;    //头像图片
@property (nonatomic,copy) NSString *count;  //关注的商品数
@property (nonatomic,copy) NSString *goods_id; //商品id
@property (nonatomic,copy) NSString *login_account; //账号：手机号
@property (nonatomic,copy) NSString *member_id; //用户ID
@property (nonatomic,copy) NSString *name; //昵称

@end
