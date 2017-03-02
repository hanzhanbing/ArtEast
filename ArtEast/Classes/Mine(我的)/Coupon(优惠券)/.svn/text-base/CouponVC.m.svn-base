//
//  CouponVC.m
//  ArtEast
//
//  Created by zyl on 16/12/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "CouponVC.h"
#import "CouponItemVC.h"
#import "OptionBarController.h"

@interface CouponVC ()
{
    NSMutableArray *_controllersArr;
}

@end

@implementation CouponVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    _controllersArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    [titleArr addObject:@"未使用"];
    [titleArr addObject:@"已使用"];
    [titleArr addObject:@"已过期"];
    
    //分类
    for (int i = 0; i<3; i++) {
        CouponItemVC *couponItemVC = [[CouponItemVC alloc] init];
        couponItemVC.title = titleArr[i];
        if (i==0) {
            couponItemVC.from = self.from;
            [couponItemVC setCouponBlock:^(NSDictionary *dic){ //选择优惠券
                [[NSNotificationCenter defaultCenter] postNotificationName:kSelectCouponSuccNotification object:dic];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        [_controllersArr addObject:couponItemVC];
    }
    
    OptionBarController *navTabBarController = [[OptionBarController alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 42) andSubViewControllers:_controllersArr andParentViewController:self andSelectedViewColor:[UIColor whiteColor] andSelectedTextColor:[UIColor blackColor] andShowSeperateLine:NO andShowBottomLine:YES andCurrentPage:0];
    navTabBarController.linecolor=LightYellowColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
