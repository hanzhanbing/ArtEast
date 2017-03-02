//
//  OrderCellFactory.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/18.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "OrderCellFactory.h"
#import "UnPayOrderCell.h"
#import "UntreatedOrderCell.h"
#import "TreatedOrderCell.h"
#import "CompletedOrderCell.h"

@implementation OrderCellFactory

+ (OrderBaseCell *)getCell:(OrderModel *)orderModel withCellStyle:(UITableViewCellStyle)cellStyle withCellIdentifier:(NSString *)reuseIdentifier {
    
    OrderBaseCell *baseCell;
    
    switch (orderModel.type) {
        case UnPayOrderType:
            baseCell = [[UnPayOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case UntreatedOrderType: //没有按钮
            baseCell = [[UntreatedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case TreatedOrderType: //2个按钮
            baseCell = [[TreatedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case UnCommentOrderType:
            baseCell = [[CompletedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case DestroyOrderType:
            baseCell = [[UntreatedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case CompletedOrderType:
            baseCell = [[UntreatedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
        case RefundOrderType:
            baseCell = [[UntreatedOrderCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
            break;
            
        default:
            break;
    }
    return baseCell;
}

+ (NSString *)getCellIdentifier:(OrderModel *)orderModel {
    
    switch (orderModel.type) {
        case UnPayOrderType:
            return [UnPayOrderCell getIdentifier];
            break;
        case UntreatedOrderType:
            return [UntreatedOrderCell getIdentifier];
            break;
        case TreatedOrderType:
            return [TreatedOrderCell getIdentifier];
            break;
        case UnCommentOrderType:
            return [CompletedOrderCell getIdentifier];
            break;
        case DestroyOrderType:
            return [UntreatedOrderCell getIdentifier];
            break;
        case CompletedOrderType:
            return [UntreatedOrderCell getIdentifier];
            break;
        case RefundOrderType:
            return [UntreatedOrderCell getIdentifier];
            break;
            
        default:
            break;
    }
    return nil;
}

+ (CGFloat)getCellHeight:(OrderModel *)orderModel {
    
    switch (orderModel.type) {
        case UnPayOrderType:
            return [UnPayOrderCell getHeight:orderModel];
            break;
        case UntreatedOrderType:
            return [UntreatedOrderCell getHeight:orderModel];
            break;
        case TreatedOrderType:
            return [TreatedOrderCell getHeight:orderModel];
            break;
        case UnCommentOrderType:
            return [CompletedOrderCell getHeight:orderModel];
            break;
        case DestroyOrderType:
            return [UntreatedOrderCell getHeight:orderModel];
            break;
        case CompletedOrderType:
            return [UntreatedOrderCell getHeight:orderModel];
            break;
        case RefundOrderType:
            return [UntreatedOrderCell getHeight:orderModel];
            break;
            
        default:
            break;
    }
    return 0;
}

@end
