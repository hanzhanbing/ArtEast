//
//  ClassifyListVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/19.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ClassifyListVC.h"
#import "AESubTypeInfo.h"
#import "ClassifySubListVC.h"
#import "OptionBarController.h"
#import "SearchVC.h"
#import "BaseWebVC.h"
#import "GoodsModel.h"
#import "BaseNC.h"
#import "GoodsDetailVC.h" //原生商品详情
#import "LoginVC.h"

@interface ClassifyListVC ()
{
    NSMutableArray *controllersArr;
}
@end

@implementation ClassifyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    [self initNav];
    
    controllersArr = [NSMutableArray array];
    
    [self getData];
    
    //改变关注图标状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectState:) name:kCollectNotification object:nil];
}

//刷新关注图标状态
-(void)changeCollectState:(NSNotification *)noti {
    NSMutableDictionary *dic = [noti object];
    NSString *index = dic[@"Index"];
    ClassifySubListVC *classifySubListVC = controllersArr[[index intValue]];
    [classifySubListVC changeCollectState:dic];
}

#pragma mark - get data

- (void)getData {
    
    //分类
    for (int i = 0; i<self.subArr.count; i++) {
        ClassifySubListVC *classifySubListVC = [[ClassifySubListVC alloc] init];
        classifySubListVC.index = [NSString stringWithFormat:@"%d",i];
        [classifySubListVC setDetailBlock:^(GoodsModel *goodsModel){ //商品详情
            GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
            goodsDetailVC.goodsModel = goodsModel;
            BaseNC *baseNC = (BaseNC *)self.navigationController;
            [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
        }];
        [classifySubListVC setLoginBlock:^(){ //登录
            LoginVC *loginVC = [[LoginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:NO];
        }];
        AESubTypeInfo *typeInfo = self.subArr[i];
        classifySubListVC.typeInfo = typeInfo;
        [controllersArr addObject:classifySubListVC];
    }
    
    OptionBarController *navTabBarController = [[OptionBarController alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 42) andSubViewControllers:controllersArr andParentViewController:self andSelectedViewColor:[UIColor whiteColor] andSelectedTextColor:[UIColor blackColor] andShowSeperateLine:NO andShowBottomLine:YES andCurrentPage:self.currentPage];
    navTabBarController.linecolor=OptionBarLineColor;
}

#pragma mark - 初始化导航条

- (void)initNav {
    //右搜索
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"SearchGray"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(WIDTH-30, 0, 30, 30);
    [rightBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - methods

//搜索
- (void)searchAction {
    DLog(@"搜索");
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UISearchBarDelegate

//跳转到搜索页面
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
