//
//  OrderVC.m
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "OrderVC.h"
#import "OrderDetailVC.h"
#import "GoodsCommentVC.h"
#import "OrderProgressVC.h"
#import "CancelOrderVC.h"
#import "ChoosePayVC.h"
#import <MJRefresh.h>
#import "BaseWebVC.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"

@interface OrderVC ()
{
    AllOrderVC *allOrderVC;
    UnPayOrderVC *unPayOrderVC;
    UntreatedOrderVC *untreatedOrderVC;
    TreatedOrderVC *treatedOrderVC;
    UnCommentOrderVC *unCommentOrderVC;
}
@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单";
    
    self.view.backgroundColor = PageColor;
    
    __weak UIViewController *weakSelf = self;
    
    //全部订单
    allOrderVC = [[AllOrderVC alloc] init];
    [allOrderVC setCancelBlock:^(NSString *orderId){ //取消订单
        _currentPage = 0;
        CancelOrderVC *cancelOrderVC = [[CancelOrderVC alloc] init];
        cancelOrderVC.orderID = orderId;
        [weakSelf.navigationController pushViewController:cancelOrderVC animated:YES];
    }];
    [allOrderVC setViewBlock:^(OrderModel *order){ //查看物流
        _currentPage = 100;
        OrderProgressVC *orderProgressVC = [[OrderProgressVC alloc] init];
        orderProgressVC.order = order;
        [weakSelf.navigationController pushViewController:orderProgressVC animated:YES];
    }];
    [allOrderVC setDetailBlock:^(OrderModel *order){ //订单详情
        _currentPage = 0;
        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
        orderDetailVC.order = order;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    [allOrderVC setPayBlock:^(OrderModel *order){ //付款
        _currentPage = 0;
        ChoosePayVC *choosePayVC = [[ChoosePayVC alloc] init];
        choosePayVC.order = order;
        [weakSelf.navigationController pushViewController:choosePayVC animated:YES];
    }];
    [allOrderVC setConfirmBlock:^(OrderModel *order){ //确认收货
        
    }];
    
    
    //待支付订单
    unPayOrderVC = [[UnPayOrderVC alloc] init];
    [unPayOrderVC setCancelBlock:^(NSString *orderId){ //取消订单
        _currentPage = 1;
        CancelOrderVC *cancelOrderVC = [[CancelOrderVC alloc] init];
        cancelOrderVC.orderID = orderId;
        [weakSelf.navigationController pushViewController:cancelOrderVC animated:YES];
    }];
    [unPayOrderVC setDetailBlock:^(OrderModel *order){ //订单详情
        _currentPage = 1;
        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
        orderDetailVC.order = order;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    [unPayOrderVC setPayBlock:^(OrderModel *order){ //付款
        _currentPage = 1;
        ChoosePayVC *choosePayVC = [[ChoosePayVC alloc] init];
        choosePayVC.order = order;
        [weakSelf.navigationController pushViewController:choosePayVC animated:YES];
    }];
    
    
    //待发货订单
    untreatedOrderVC = [[UntreatedOrderVC alloc] init];
    [untreatedOrderVC setDetailBlock:^(OrderModel *order){ //订单详情
        _currentPage = 2;
        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
        orderDetailVC.order = order;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    
    //已发货订单
    treatedOrderVC = [[TreatedOrderVC alloc] init];
    [treatedOrderVC setViewBlock:^(OrderModel *order){ //查看物流
        _currentPage = 100;
        OrderProgressVC *orderProgressVC = [[OrderProgressVC alloc] init];
        orderProgressVC.order = order;
        [weakSelf.navigationController pushViewController:orderProgressVC animated:YES];
    }];
    [treatedOrderVC setDetailBlock:^(OrderModel *order){ //订单详情
        _currentPage = 3;
        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
        orderDetailVC.order = order;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    [treatedOrderVC setConfirmBlock:^(OrderModel *order){ //确认收货
        
    }];
    
    
    //待评论订单
    unCommentOrderVC = [[UnCommentOrderVC alloc] init];
    [unCommentOrderVC setCommentBlock:^(OrderModel *order){ //去评价
        _currentPage = 4;
        GoodsCommentVC *goodsCommentVC = [[GoodsCommentVC alloc] init];
        goodsCommentVC.order = order;
        [weakSelf.navigationController pushViewController:goodsCommentVC animated:YES];
    }];
    [unCommentOrderVC setDetailBlock:^(GoodsModel *goodsModel){ //商品详情
        //[BaseWebVC showWithContro:weakSelf withUrlStr:order.url withTitle:@"商品详情"];
        _currentPage = 100;
        GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
        goodsDetailVC.goodsModel = goodsModel;
        BaseNC *baseNC = (BaseNC *)weakSelf.navigationController;
        [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
    }];
    
    
    NSArray *controllersArr = @[allOrderVC, unPayOrderVC, untreatedOrderVC, treatedOrderVC,unCommentOrderVC];
    OptionBarController *navTabBarController = [[OptionBarController alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 42) andSubViewControllers:controllersArr andParentViewController:self andSelectedViewColor:[UIColor whiteColor] andSelectedTextColor:[UIColor blackColor] andShowSeperateLine:NO andShowBottomLine:YES andCurrentPage:_currentPage];
    navTabBarController.linecolor=LightYellowColor;
    
    //自动下拉刷新
    navTabBarController.clickBlock = ^(NSInteger currentIndex){
        switch (currentIndex) {
            case 0:
                [allOrderVC.tableView.mj_header beginRefreshing];
                break;
            case 1:
                [unPayOrderVC.tableView.mj_header beginRefreshing];
                break;
            case 2:
                [untreatedOrderVC.tableView.mj_header beginRefreshing];
                break;
            case 3:
                [treatedOrderVC.tableView.mj_header beginRefreshing];
                break;
            case 4:
                [unCommentOrderVC.tableView.mj_header beginRefreshing];
                break;
                
            default:
                break;
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[UIImage new]];
    
    switch (_currentPage) {
        case 0:
            [allOrderVC.tableView.mj_header beginRefreshing];
            break;
        case 1:
            [unPayOrderVC.tableView.mj_header beginRefreshing];
            break;
        case 2:
            [untreatedOrderVC.tableView.mj_header beginRefreshing];
            break;
        case 3:
            [treatedOrderVC.tableView.mj_header beginRefreshing];
            break;
        case 4:
            [unCommentOrderVC.tableView.mj_header beginRefreshing];
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:nil];
}

//返回我的页面
- (void)backAction {
    if ([self.fromFlag isEqualToString:@"跳转"]) {
        //self.tabBarController.selectedIndex = 4;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
