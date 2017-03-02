//
//  FineGoodsVC.m
//  ArtEast
//
//  Created by yibao on 16/11/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "FineGoodsVC.h"
#import "ClassifyHomeVC.h"
#import "GoodsGridListVC.h"
#import "ShoppingCartVC.h"
#import "GoodsListViewController.h"
#import "OptionBarController.h"
#import "SearchVC.h"
#import "AETypeInfo.h"
#import "BaseWebVC.h"
#import "GoodsModel.h"
#import "BaseNC.h"
#import "GoodsDetailVC.h" //原生商品详情
#import "LoginVC.h"
#import <MJRefresh.h>
#import "WelfareCenterVC.h"
#import "AEImages.h"
#import "AEUpdateView.h"

@interface FineGoodsVC ()<UISearchBarDelegate,RefreshDelegate>
{
    ClassifyHomeVC *classifyHomeVC;
    NSMutableArray *controllersArr;
    NSMutableArray *categoryArr;
    UIButton *shoppingCartBtn;
    
    UIView *topView;
    UISearchBar *searchBar;
    DefaultView *_defaultView;
    
    UIButton *leftClickBtn;
    UIButton *rightClickBtn;
    UIButton *iconNum;
    UIImageView *tabbarImgView;
}
@end

@implementation FineGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"佑生活";
    
    [self initNav];
    
    [self blankView];
    
    controllersArr = [NSMutableArray array];
    categoryArr = [NSMutableArray array];
    
    [self getData];
    
    shoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-65, HEIGHT-140, 57.5, 57.5)];
    [shoppingCartBtn setImage:[UIImage imageNamed:@"Cart"] forState:UIControlStateNormal];
    [shoppingCartBtn addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    //[[UIApplication sharedApplication].keyWindow addSubview:shoppingCartBtn];
    
    /*创建弹性动画
     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
     velocity:弹性复位的速度
     */
    [UIView animateWithDuration:0.5 delay:0.03 usingSpringWithDamping:0.1 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        shoppingCartBtn.center=CGPointMake(WIDTH-65+57.5/2, HEIGHT-125+57.5/2);
    } completion:nil];
    
    //改变关注图标状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectState:) name:kCollectNotification object:nil];
    
    tabbarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    [self.view addSubview:tabbarImgView];
    
    [self checkUpdate]; //版本更新
}

//刷新关注图标状态
-(void)changeCollectState:(NSNotification *)noti {
    
    NSMutableDictionary *dic = [noti object];
    
    NSString *index = dic[@"Index"];
    
    GoodsGridListVC *GoodsGridListVC = controllersArr[[index intValue]];
    
    [GoodsGridListVC changeCollectState:dic];
}

#pragma mark - 版本更新

- (void)checkUpdate {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2", @"version_type",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_VersionUpdate parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                //新版本
                NSString *newVersion = responseData[@"version_number"];
                //获取本地app当前版本号
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
                
                if ([newVersion floatValue] > [currentVersion floatValue]) {
                    NSArray *textArr = [responseData[@"version_content"] componentsSeparatedByString:@";"];
                    
                    AEUpdateView *alert = [[AEUpdateView alloc] initWithImage:[UIImage imageNamed:@"UpdateBg"] versionText:[NSString stringWithFormat:@"%@",responseData[@"version_number"]] contentText:textArr leftButtonTitle:@"以后再说" rightButtonTitle:@"App Store"];
                    alert.animationStyle = ASAnimationTopShake; //从上到下动画
                    if ([responseData[@"update_type"] isEqualToString:@"2"]) {
                        alert.dontDissmiss = YES; //强制更新
                    }
                    alert.doneBlock = ^()
                    {
                        NSLog(@"跳到AppStore");
                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:responseData[@"version_download"]]]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseData[@"version_download"]]];
                        }
                    };
                }
            }
        }
    }];
}

#pragma mark - 初始化导航条

- (void)initNav {
    //左搜索
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"SearchGray"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    leftBtn.userInteractionEnabled = NO;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navItem.leftBarButtonItem = leftBarButtonItem;
    
    //右购物车
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"CartGray"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(WIDTH-30, 0, 30, 30);
    rightBtn.userInteractionEnabled = NO;
    
    //数量提示
    iconNum = [[UIButton alloc] initWithFrame:CGRectMake(14, -2, 17, 17)];
    iconNum.hidden = YES;
    iconNum.backgroundColor = LightYellowColor;
    iconNum.titleLabel.font = [UIFont systemFontOfSize:10];
    [iconNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    iconNum.layer.cornerRadius = 8.5;
    iconNum.userInteractionEnabled = NO;
    [rightBtn addSubview:iconNum];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navItem.rightBarButtonItem = rightBarButtonItem;
    
    leftClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 14, 50, 50)];
    [leftClickBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:leftClickBtn];
    
    rightClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-55, 14, 50, 50)];
    [rightClickBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:rightClickBtn];
}

- (void)getCartNum {
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:kCartCount];
    if ([Utils isBlankString:result]||[result isEqualToString:@"0"]) {
        iconNum.hidden = YES;
    } else {
        iconNum.hidden = NO;
        [iconNum setTitle:result forState:UIControlStateNormal];
    }
}

#pragma mark - methods

//购物车
- (void)cartAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        ShoppingCartVC *shoppingCartVC = [[ShoppingCartVC alloc] init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        shoppingCartVC.isTabbarHidder = YES;
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    } else {
        //跳到登录页面
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//搜索
- (void)searchAction {
    DLog(@"搜索");
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - get data

- (void)getData {
    
    __weak UIViewController *weakSelf = self;
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetCatesList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            shoppingCartBtn.hidden = NO;
            _defaultView.hidden = YES;
            
            categoryArr = [AETypeInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            //分类首页
            classifyHomeVC = [[ClassifyHomeVC alloc] init];
            classifyHomeVC.title = @"首页";
            __weak UIViewController *weakSelf = self;
            [classifyHomeVC setDetailBlock:^(GoodsModel *goodsModel){ //原生商品详情
                if (![Utils isBlankString:goodsModel.ID]) {
                    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
                    goodsDetailVC.hidesBottomBarWhenPushed = YES;
                    goodsDetailVC.goodsModel = goodsModel;
                    goodsDetailVC.hideAnimation = YES;
                    BaseNC *baseNC = (BaseNC *)weakSelf.navigationController;
                    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
                }
            }];
            
            //图片轮播跳转(首页banner、设计师说、精选专题)
            [classifyHomeVC setImageRollBlock:^(AEImages *images){
                if (![Utils isBlankString:images.url_type]) {
                    if ([images.url_type isEqualToString:@"h5"]) {
                        [BaseWebVC showWithContro:weakSelf withUrlStr:images.ad_url withTitle:@"" isPresent:NO withShareContent:images.desc];
                    }
                    
                    if ([images.url_type isEqualToString:@"app"]) {
                        if ([images.app[@"type"] isEqualToString:@"list"]) { //商品列表
                            if ([images.app[@"param"] isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *paramDic = images.app[@"param"];
                                GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] init];
                                goodsListVC.hidesBottomBarWhenPushed = YES;
                                goodsListVC.virtual_cat_id = paramDic[@"keyid"];
                                goodsListVC.virtual_cat_name = images.ca_name;
                                [weakSelf.navigationController pushViewController:goodsListVC animated:YES];
                            }
                        }
                        
                        if ([images.app[@"type"] isEqualToString:@"detail"]) { //商品详情
                            if ([images.app[@"param"] isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *paramDic = images.app[@"param"];
                                GoodsModel *goodsModel = [[GoodsModel alloc] init];
                                goodsModel.icon = @"";
                                goodsModel.ID = paramDic[@"keyid"];
                                GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
                                goodsDetailVC.hidesBottomBarWhenPushed = YES;
                                goodsDetailVC.goodsModel = goodsModel;
                                goodsDetailVC.hideAnimation = YES;
                                BaseNC *baseNC = (BaseNC *)weakSelf.navigationController;
                                [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
                            }
                        }
                    }
                }
            }];
            
            //网页跳转
            [classifyHomeVC setWebBlock:^(NSString *webUrl){
                [BaseWebVC showWithContro:weakSelf withUrlStr:webUrl withTitle:@"" isPresent:NO withShareContent:@""];
            }];
            
            //福利中心跳转
            [classifyHomeVC setWelfareBlock:^(){
                WelfareCenterVC *welfareCenterVC = [[WelfareCenterVC alloc] init];
                welfareCenterVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:welfareCenterVC animated:NO];
            }];
            
            //登录跳转
            [classifyHomeVC setLoginBlock:^(){
                LoginVC *loginVC = [[LoginVC alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:loginVC animated:NO];
            }];
            
            [controllersArr addObject:classifyHomeVC];
        
            //分类
            for (int i = 0; i<categoryArr.count; i++) {
                GoodsGridListVC *goodsGridListVC = [[GoodsGridListVC alloc] init];
                goodsGridListVC.index = [NSString stringWithFormat:@"%d",i];
                [goodsGridListVC setDetailBlock:^(GoodsModel *goodsModel){ //商品详情
                    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
                    goodsDetailVC.goodsModel = goodsModel;
                    BaseNC *baseNC = (BaseNC *)self.navigationController;
                    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
                }];
                [goodsGridListVC setLoginBlock:^(){ //登录
                    LoginVC *loginVC = [[LoginVC alloc] init];
                    loginVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:loginVC animated:NO];
                }];
                AETypeInfo *typeInfo = categoryArr[i];
                goodsGridListVC.typeInfo = typeInfo;
                [controllersArr addObject:goodsGridListVC];
            }
            
            OptionBarController *navTabBarController = [[OptionBarController alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 42) andSubViewControllers:controllersArr andParentViewController:self andSelectedViewColor:[UIColor whiteColor] andSelectedTextColor:[UIColor blackColor] andShowSeperateLine:NO andShowBottomLine:YES andCurrentPage:0];
            navTabBarController.linecolor=OptionBarLineColor;
        } else {
            shoppingCartBtn.hidden = YES;
            _defaultView.hidden = NO;
            _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
            _defaultView.lab.text = @"网络状态待提升，点击重试";
        }
    }];
}

#pragma mark - UISearchBarDelegate

//跳转到搜索页面
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}

#pragma mark - 购物车

//跳转购物车
- (void)shoppingCart {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        ShoppingCartVC *shoppingCartVC = [[ShoppingCartVC alloc] init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        shoppingCartVC.isTabbarHidder = YES;
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    } else {
        //跳到登录页面
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//有网络了
//- (void)netWorkAppear
//{
//    [super netWorkAppear];
//
//    [self refresh];
//}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:self.tableFrame];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    shoppingCartBtn.hidden = NO;
    _defaultView.hidden = YES;
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[UIImage new]];
    
    shoppingCartBtn.hidden = NO;
    leftClickBtn.hidden = NO;
    rightClickBtn.hidden = NO;
    [self getCartNum]; //获取购物车数量
    //topView.hidden = NO;
    
    //self.navBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:nil];
    
    shoppingCartBtn.hidden = YES;
    leftClickBtn.hidden = YES;
    rightClickBtn.hidden = YES;
//    topView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
    if (!tabbarImgView.image) {
        tabbarImgView.image = [self snapshotSingleView:self.tabBarController.tabBar];
    }
}

#pragma mark - 屏幕快照
- (UIImage *)snapshotSingleView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
