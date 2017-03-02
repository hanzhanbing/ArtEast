//
//  PayResultVC.m
//  ArtEast
//
//  Created by yibao on 16/11/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "PayResultVC.h"
#import "OrderVC.h"

@interface PayResultVC ()
{
    UILabel *resultLab;
    UILabel *resultTipLab;
    
    UIButton *showOrderBtn;
    UIButton *rePayBtn;
    
    UILabel *nameLab;
    UILabel *phoneLab;
    UILabel *addressLab;
    
    UILabel *payWayLab;
    UILabel *moneyLab;
}
@end

@implementation PayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"付款结果";
    
    //付款结果
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, WIDTH, 230)];
    resultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:resultView];
    
    resultLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-35, 45, 75, 20)];
    resultLab.textColor = AppThemeColor;
    resultLab.font = [UIFont systemFontOfSize:18];
    [resultView addSubview:resultLab];
    
    resultTipLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-130, resultLab.maxY+15, 260, 36)];
    resultTipLab.numberOfLines = 2;
    resultTipLab.font = [UIFont systemFontOfSize:13];
    resultTipLab.textColor = PlaceHolderColor;
    resultTipLab.textAlignment = NSTextAlignmentCenter;
    [resultView addSubview:resultTipLab];
    
    showOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2-110, resultTipLab.maxY+30, 100, 40)];
    showOrderBtn.titleLabel.font = kFont14Size;
    [showOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showOrderBtn.layer.borderColor = LineColor.CGColor;
    showOrderBtn.layer.borderWidth = 0.5;
    [showOrderBtn addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:showOrderBtn];
    
    rePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(showOrderBtn.maxX+20, resultTipLab.maxY+30, 100, 40)];
    rePayBtn.titleLabel.font = kFont14Size;
    [rePayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rePayBtn.layer.borderColor = LineColor.CGColor;
    rePayBtn.layer.borderWidth = 0.5;
    [rePayBtn addTarget:self action:@selector(rePay) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:rePayBtn];
    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, rePayBtn.maxY+45, WIDTH-15, 0.5)];
//    line1.backgroundColor = LineColor;
//    [resultView addSubview:line1];
//    
//    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, line1.maxY+10, 80, 20)];
//    nameLab.textAlignment = NSTextAlignmentLeft;
//    nameLab.font = kFont14Size;
//    nameLab.textColor = [UIColor blackColor];
//    [resultView addSubview:nameLab];
//    
//    phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.maxX, line1.maxY+10, 100, 20)];
//    phoneLab.textAlignment = NSTextAlignmentLeft;
//    phoneLab.font = kFont14Size;
//    phoneLab.textColor = [UIColor blackColor];
//    [resultView addSubview:phoneLab];
//    
//    addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15, nameLab.maxY+5, WIDTH-30, 20)];
//    addressLab.textAlignment = NSTextAlignmentLeft;
//    addressLab.font = kFont14Size;
//    addressLab.textColor = [UIColor blackColor];
//    [resultView addSubview:addressLab];
//    
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, line1.maxY+65, WIDTH-15, 0.5)];
//    line2.backgroundColor = LineColor;
//    [resultView addSubview:line2];
//    
//    UILabel *payWayTipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, line2.maxY+10, 80, 20)];
//    payWayTipLab.textAlignment = NSTextAlignmentLeft;
//    payWayTipLab.font = kFont14Size;
//    payWayTipLab.textColor = [UIColor blackColor];
//    payWayTipLab.text = @"支付方式：";
//    [resultView addSubview:payWayTipLab];
//    
//    payWayLab = [[UILabel alloc] initWithFrame:CGRectMake(payWayTipLab.maxX, line2.maxY+10, 100, 20)];
//    payWayLab.textAlignment = NSTextAlignmentLeft;
//    payWayLab.font = kFont14Size;
//    payWayLab.textColor = [UIColor blackColor];
//    [resultView addSubview:payWayLab];
//    
//    UILabel *moneyTipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, payWayTipLab.maxY+5, 80, 20)];
//    moneyTipLab.textAlignment = NSTextAlignmentLeft;
//    moneyTipLab.font = kFont14Size;
//    moneyTipLab.textColor = [UIColor blackColor];
//    moneyTipLab.text = @"实付：";
//    [resultView addSubview:moneyTipLab];
//    
//    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(moneyTipLab.maxX, payWayTipLab.maxY+5, 100, 20)];
//    moneyLab.textAlignment = NSTextAlignmentLeft;
//    moneyLab.font = kFont14Size;
//    moneyLab.textColor = [UIColor blackColor];
//    [resultView addSubview:moneyLab];
    
    if (self.isSuccess) { //付款成功
        resultLab.text = @"付款成功";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"买家已付款\n您的包裹正在出库"];
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:13.0]
                              range:NSMakeRange(3, 3)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:AppThemeColor
                              range:NSMakeRange(3, 3)];
        resultTipLab.attributedText = AttributedStr;
        [rePayBtn setTitle:@"去首页" forState:UIControlStateNormal];
    } else { //付款失败
        resultLab.text = @"付款失败";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"请在 1小时 内完成付款\n否则订单会被系统取消"];
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:13.0]
                              range:NSMakeRange(3, 3)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:AppThemeColor
                              range:NSMakeRange(3, 3)];
        resultTipLab.attributedText = AttributedStr;
        [rePayBtn setTitle:@"重新付款" forState:UIControlStateNormal];
    }
    
    [showOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
}

#pragma mark - methods

//查看订单
- (void)showOrder {
    if (self.isSuccess) { //待发货订单
        OrderVC *orderVC = [[OrderVC alloc] init];
        orderVC.currentPage = 2;
        orderVC.fromFlag = @"跳转";
        [self.navigationController pushViewController:orderVC animated:YES];
    } else { //待付款订单
        OrderVC *orderVC = [[OrderVC alloc] init];
        orderVC.currentPage = 1;
        orderVC.fromFlag = @"跳转";
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

//重新付款
- (void)rePay {
    if ([rePayBtn.titleLabel.text isEqualToString:@"重新付款"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([rePayBtn.titleLabel.text isEqualToString:@"去首页"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

//返回
- (void)backAction {
    if (self.isSuccess) { //待发货订单
        OrderVC *orderVC = [[OrderVC alloc] init];
        orderVC.currentPage = 2;
        orderVC.fromFlag = @"跳转";
        [self.navigationController pushViewController:orderVC animated:YES];
    } else { //待付款订单
        OrderVC *orderVC = [[OrderVC alloc] init];
        orderVC.currentPage = 1;
        orderVC.fromFlag = @"跳转";
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
