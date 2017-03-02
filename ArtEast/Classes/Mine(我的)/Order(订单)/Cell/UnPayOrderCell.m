//
//  UnPayOrderCell.m
//  ArtEast
//
//  Created by yibao on 16/11/7.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UnPayOrderCell.h"
#import <UIImageView+AFNetworking.h>

@interface UnPayOrderCell ()
{
    UILabel *_orderLab;
    UILabel *_statusLab;
    UILabel *_nameLab;
    UILabel *_countLab;
    UILabel *_countDesLab;
    UILabel *_totalMoneyLab;
    UIView  *_bottomLine;
    UIButton *_cancelBtn; //取消订单
    UIButton *_payBtn; //去支付
    OrderModel *_orderModel;
}
@end

@implementation UnPayOrderCell

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
    _statusLab.text = @"待付款";
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
    
    _countDesLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, WIDTH-125, 20)];
    _countDesLab.font = [UIFont systemFontOfSize:12];
    _countDesLab.textColor = PlaceHolderColor;
    [goodsItemView addSubview:_countDesLab];
    
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
    
    //取消订单
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-170, CGRectGetMaxY(line.frame)+10, 70, 30)];
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = PlaceHolderColor.CGColor;
    _cancelBtn.cornerRadius = 5;
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-85, CGRectGetMaxY(line.frame)+10, 70, 30)];
    _payBtn.layer.borderWidth = 1;
    _payBtn.layer.borderColor = AppThemeColor.CGColor;
    _payBtn.cornerRadius = 5;
    [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payBtn];
}

- (void)setContentView:(OrderModel *)orderModel {
    
    _orderModel = orderModel;

    _orderLab.text = [NSString stringWithFormat:@"订单编号：%@",_orderModel.ID];
    
    NSMutableArray *goodsArr = _orderModel.goodsArr;
    
    [self.goodsImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureUrl,goodsArr[0][@"thumbnail_pic_src"]]]
              placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    
    _nameLab.text = [goodsArr[0][@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _countLab.text = [NSString stringWithFormat:@"数量：X%@",_orderModel.itemnum];
    
    _countDesLab.text = [NSString stringWithFormat:@"(共%lu件商品)",(unsigned long)goodsArr.count];
    
    _totalMoneyLab.text = [NSString stringWithFormat:@"￥%@",_orderModel.total_amount];
}

#pragma mark - event response
//取消订单
- (void)cancelAction:(UIButton *)btn {
    NSLog(@"取消订单");
    if ([self.delegate respondsToSelector:@selector(clickCancelOrder:)]) {
        [self.delegate clickCancelOrder:_orderModel.ID];
    }
}

//付款
- (void)payAction:(UIButton *)btn {
    NSLog(@"付款");
    if ([self.delegate respondsToSelector:@selector(clickPayOrder:)]) {
        [self.delegate clickPayOrder:_orderModel];
    }
}

+ (NSString *)getIdentifier {
    return @"UnPayOrderIdentifier";
}

+ (CGFloat)getHeight:(OrderModel *)orderModel {
    return 200;
}

@end
