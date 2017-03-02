//
//  FindVC.m
//  ArtEast
//
//  Created by yibao on 16/11/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "FindVC.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "SearchVC.h"
#import <UIButton+AFNetworking.h>
#import "DefaultView.h"
#import "BaseWebVC.h"
#import "GoodsListViewController.h"
#import "AEImages.h"
#import "AppDelegate.h"
#import "BaseNC.h"
#import "GoodsDetailVC.h"

@interface FindVC ()<RefreshDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) DefaultView *defaultView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FindVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES; //隐藏导航条
    
    if (_dataSource.count == 0) {
        [self getData]; //获取网络数据
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSMutableArray array];
    
    [self initView]; //首页H5
    
    //[self LaunchImage]; //启动图动画
    
    [self blankView]; //空白页
    [self getData]; //获取网络数据
    
    [self getCartNum]; //获取购物车数量
}

- (void)getCartNum {
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserInfo share].userID, @"memberID",
                          nil];
    [[NetworkManager sharedManager] postJSON:URL_GetCartNum parameters:dic3 imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            NSString *result = [NSString stringWithFormat:@"%@",responseData];
            
            if ([result isEqualToString:@"0"]) {
                //隐藏
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            } else {
                //显示
                [self.tabBarController.tabBar showBadgeOnItemIndex:3 andCount:result];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:kCartCount];
        }
    }];
}

#pragma mark - 启动插图

- (void)LaunchImage {
    
    //启动插图
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *startView = [[[NSBundle mainBundle] loadNibNamed:@"StartView" owner:nil options:nil] firstObject];
    startView.frame = [[UIScreen mainScreen] bounds];
    [app.window addSubview:startView];
    
    UIImageView *imgView = [startView viewWithTag:100];
    imgView.frame = [[UIScreen mainScreen] bounds];
    
    [UIView animateWithDuration:0.5 animations:^{
        startView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
        [self blankView]; //空白页
        [self getData]; //获取网络数据
    }];
}

#pragma mark - get data

- (void)getData {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"position",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetFindImages parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            _pageFlowView.hidden = NO;
            _defaultView.hidden = YES;
            [_dataSource removeAllObjects];
            _dataSource = [AEImages mj_objectArrayWithKeyValuesArray:responseData];
            [_pageFlowView reloadData];
            
            [UIView animateWithDuration:1 animations:^{
                _pageFlowView.alpha = 1;
            }];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _pageFlowView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = self;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
                _defaultView.lab.text = @"网络状态待提升，点击重试";
            });
        }
    }];
}

#pragma mark - init view

- (void)initView {
    
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-150)];
    _pageFlowView.alpha = 0;
    _pageFlowView.backgroundColor = [UIColor clearColor];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.1;
    _pageFlowView.minimumPageScale = 0.85;
    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    _pageFlowView.isOpenAutoScroll = NO;
    
    //    //提前告诉有多少页
    //    pageFlowView.orginPageCount = self.imageArray.count;
    //
    //    //初始化pageControl
    //    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24 - 8, WIDTH, 8)];
    //    pageFlowView.pageControl = pageControl;
    //    pageControl.pageIndicatorTintColor = LightBlackColor;
    //    pageControl.currentPageIndicatorTintColor = AppThemeColor;
    //    [pageFlowView addSubview:pageControl];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [bottomScrollView addSubview:_pageFlowView];
    
    [_pageFlowView reloadData];
    
    [self.view addSubview:bottomScrollView];
}

//导航条
- (void)initNav {
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-85, 45, 50, 0.5)];
    leftLine.backgroundColor = LightBlackColor;
    [self.view addSubview:leftLine];
    
    UILabel *thirdLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-50, 35, 100, 20)];
    thirdLab.text = @"发现";
    thirdLab.textAlignment = NSTextAlignmentCenter;
    thirdLab.font = kFont18Size;
    thirdLab.textColor = LightBlackColor;
    [self.view addSubview:thirdLab];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2+40, 45, 50, 0.5)];
    rightLine.backgroundColor = LightBlackColor;
    [self.view addSubview:rightLine];
}

#pragma mark - NewPagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(WIDTH - 84, HEIGHT-150);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    AEImages *images = self.dataSource[subIndex];
    
    if (![Utils isBlankString:images.url_type]) {
        if ([images.url_type isEqualToString:@"h5"]) {
            [BaseWebVC showWithContro:self withUrlStr:images.ad_url withTitle:@"" isPresent:NO withShareContent:images.desc];
        }
        
        if ([images.url_type isEqualToString:@"app"]) {
            if ([images.app[@"type"] isEqualToString:@"list"]) { //商品列表
                if ([images.app[@"param"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *paramDic = images.app[@"param"];
                    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] init];
                    goodsListVC.hidesBottomBarWhenPushed = YES;
                    goodsListVC.virtual_cat_id = paramDic[@"keyid"];
                    goodsListVC.virtual_cat_name = images.ca_name;
                    [self.navigationController pushViewController:goodsListVC animated:YES];
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
                    BaseNC *baseNC = (BaseNC *)self.navigationController;
                    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
                }
            }
        }
    }
}

#pragma mark - NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.dataSource.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 84, HEIGHT-150)];
        bannerView.layer.cornerRadius = 0;
        bannerView.layer.masksToBounds = NO;
    }
    //在这里下载网络图片
    AEImages *images = self.dataSource[index];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:images.ad_img] placeholderImage:[UIImage imageNamed:@"BookDefaultIcon"]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    //NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark - 网络

//有网络了
//- (void)netWorkAppear
//{
//    [super netWorkAppear];
//    
//    [self getData];
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
    _pageFlowView.hidden = NO;
    _defaultView.hidden = YES;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
