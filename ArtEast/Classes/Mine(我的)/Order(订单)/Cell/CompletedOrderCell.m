//
//  CompletedOrderCell.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/18.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "CompletedOrderCell.h"
#import <UIImageView+AFNetworking.h>

@interface CompletedOrderCell ()
{
    UILabel *_orderLab;
    UILabel *_statusLab;
    UILabel *_nameLab;
    UILabel *_countLab;
    UILabel *_totalMoneyLab;
    UIView  *_bottomLine;
    UIButton *_commentBtn; //去评价
    OrderModel *_orderModel;
}
@end

@implementation CompletedOrderCell

- (void)addContentView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    //订单编号
    _orderLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH-20, 50)];
    _orderLab.font = [UIFont systemFontOfSize:13];
    _orderLab.text = @"订单编号：";
    _orderLab.textColor = PlaceHolderColor;
    [self addSubview:_orderLab];
    
    //订单状态
    _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-76, 0, 60, 50)];
    _statusLab.text = @"待评价";
    _statusLab.font = [UIFont systemFontOfSize:13];
    _statusLab.textColor = PlaceHolderColor;
    _statusLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_statusLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, 1)];
    lineView.backgroundColor = kColorFromRGBHex(0xECECEC);
    [self addSubview:lineView];
    
    UIView *goodsItemView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), WIDTH, 100)];
    [self addSubview:goodsItemView];
    
    self.goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 80, 80)];
    self.goodsImg.image = [UIImage imageNamed:@"GoodsDefault"];
    [goodsItemView addSubview:self.goodsImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, WIDTH-125, 20)];
    _nameLab.font = kFont13Size;
    _nameLab.textColor = [UIColor blackColor];
    [goodsItemView addSubview:_nameLab];
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, WIDTH-125, 20)];
    _countLab.font = [UIFont systemFontOfSize:12];
    _countLab.textColor = PlaceHolderColor;
    [goodsItemView addSubview:_countLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, goodsItemView.maxY, WIDTH, 1.0)];
    line.backgroundColor = kColorFromRGBHex(0xECECEC);
    [self addSubview:line];
    
    //总计
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line.frame), WIDTH/2, 50)];
    totalLab.font = [UIFont systemFontOfSize:13];
    totalLab.textColor = LightBlackColor;
    totalLab.text = @"总计：";
    [self addSubview:totalLab];
    
    _totalMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(line.frame), WIDTH/2, 50)];
    _totalMoneyLab.font = kFont14Size;
    _totalMoneyLab.textColor = PriceRedColor;
    [self addSubview:_totalMoneyLab];
    
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-85, CGRectGetMaxY(line.frame)+10, 70, 30)];
    _commentBtn.layer.borderWidth = 1;
    _commentBtn.layer.borderColor = AppThemeColor.CGColor;
    _commentBtn.cornerRadius = 5;
    [_commentBtn setTitle:@"去评价" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
}

- (void)setContentView:(OrderModel *)orderModel {
    
    _orderModel = orderModel;
    
    _orderLab.text = [NSString stringWithFormat:@"订单编号：%@",_orderModel.ID];
    
    [self.goodsImg setImageWithURL:[NSURL URLWithString:_orderModel.thumbnail_pic_src]
              placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    
    _nameLab.text = _orderModel.name;
    
    _countLab.text = [NSString stringWithFormat:@"数量：X%@",_orderModel.itemnum];
    
    _totalMoneyLab.text = [NSString stringWithFormat:@"￥%@",_orderModel.total_amount];
}

#pragma mark - event response

//去评价
- (void)commentAction:(UIButton *)btn {
    //NSLog(@"去评价");
    if ([self.delegate respondsToSelector:@selector(clickCommentOrder:)]) {
        [self.delegate clickCommentOrder:_orderModel];
    }
}

+ (NSString *)getIdentifier {
    return @"CompletedOrderIdentifier";
}

+ (CGFloat)getHeight:(OrderModel *)orderModel {
    return 200;
}

@end
