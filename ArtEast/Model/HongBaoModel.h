//
//  HongBaoModel.h
//  ArtEast
//
//  Created by yibao on 2017/1/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  红包Model
 */

#import <Foundation/Foundation.h>

@interface HongBaoModel : NSObject

@property (nonatomic,copy) NSString *alttime; //操作时间
@property (nonatomic,copy) NSString *log_id; //名称
@property (nonatomic,copy) NSString *log_text; //备注
@property (nonatomic,copy) NSString *member_id; //会员ID
@property (nonatomic,copy) NSString *operate_name; //操作类型名称
@property (nonatomic,copy) NSString *operate_type; //操作类型
@property (nonatomic,copy) NSString *order_id; //订单号
@property (nonatomic,copy) NSString *red_packets_amount; //红包变动金额

@end
