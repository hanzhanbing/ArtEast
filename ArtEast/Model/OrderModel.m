//
//  OrderModel.m
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"goodsArr":@"goods_items",
             @"ID":@"order_id",
             };
}

- (void)setOrder_status:(NSString *)order_status {
    if (_order_status != order_status) {
        _order_status = order_status;
        
        NSLog(@"订单状态：%@",_order_status);
        
        if ([_order_status isEqualToString:@"等待付款"]) {
            _type = UnPayOrderType; //待付款
        }
        
        else if ([_order_status isEqualToString:@"已支付[未发货]"]) {
            _type = UntreatedOrderType; //待发货
        }
        
        else if ([_order_status isEqualToString:@"已支付[已发货]"]) {
            _type = TreatedOrderType; //已发货
        }
        
        else if ([_order_status isEqualToString:@"待评价"]) {
            _type = UnCommentOrderType; //待评价
        }
        
        else if ([_order_status isEqualToString:@"已作废"]) {
            _type = DestroyOrderType; //已作废
        }
        
        else if ([_order_status isEqualToString:@"已完成"]) {
            _type = CompletedOrderType; //已完成
        }
        
        else {
            _type = RefundOrderType; //其他情况，如退货
        }
    }
}

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = [NSString stringWithFormat:@"%@%@",PictureUrl,url];
    }
}

- (void)setThumbnail_pic_src:(NSString *)thumbnail_pic_src {
    if (_thumbnail_pic_src != thumbnail_pic_src) {
        _thumbnail_pic_src = [NSString stringWithFormat:@"%@%@",PictureUrl,thumbnail_pic_src];
    }
}

- (void)setName:(NSString *)name {
    if (_name != name) {
        _name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

@end
