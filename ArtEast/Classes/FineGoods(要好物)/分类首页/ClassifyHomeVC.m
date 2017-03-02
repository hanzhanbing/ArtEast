//
//  ClassifyHomeVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/16.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ClassifyHomeVC.h"
#import "GridListCell.h"
#import "BannerView.h"
#import "LimitBuyView.h"
#import "DesignerSayView.h"
#import "WelfareCenterView.h"
#import "NewProductsView.h"
#import "BestProjectView.h"
#import "AEImages.h"
#import <MJRefresh.h>
#import "BaseWebVC.h"

@interface ClassifyHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    // 倒计时
    NSTimer *showTimer;
    UIBackgroundTaskIdentifier taskID;
}
@property (nonatomic,strong) NSMutableArray *bannerArr; //轮播图
@property (nonatomic,strong) NSMutableDictionary *limitDic; //限时购
@property (nonatomic,strong) NSMutableArray *designerSayArr; //设计师说
@property (nonatomic,strong) NSMutableArray *welfareCenterArr; //福利中心
@property (nonatomic,strong) NSMutableArray *bestProjectArr; //精选专题
@property (nonatomic,strong) NSMutableArray *productsArr; //人气新品
@property (nonatomic,strong) NSMutableArray *goodsRecommendArr; //好物推荐

@end

@implementation ClassifyHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [self limitBuyData]; //限时购
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PageColor;
    
    _limitDic = [NSMutableDictionary dictionary];
    _productsArr = [NSMutableArray array];
    _goodsRecommendArr = [NSMutableArray array];
    
    //UICollectionView
    [self.view addSubview:self.mainCollectionView];
    
    [self getData];
}

- (void)timeDecreasing {
    
    int seconds = [_limitDic[@"daojishi"] intValue];
    NSLog(@"%d",seconds);
    _limitDic[@"daojishi"] = [NSString stringWithFormat:@"%d",seconds-1];
    
    // 活动结束
    if(seconds<=0) {
        if (showTimer) {
            
            [showTimer invalidate];
            [self endBack];
            showTimer = nil;
        }
        //cell.isEnd = YES;
    } else {
        //cell.isEnd = NO;
    }
    // 更新时间
    [UIView performWithoutAnimation:^{ //局部更新，避免闪烁
        [_mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }];
}

#pragma mark - Get Data

- (void)getData {
    [self bannerData]; //广告轮播图
    [self limitBuyData]; //限时购
    [self designerSayData]; //设计师说
    [self welfareCenter]; //福利中心
    [self bestProjectData]; //精选专题
    [self goodProductData]; //好物推荐
    
    [JHHJView hideLoading]; //结束加载
    [_mainCollectionView.mj_header endRefreshing];
    [_mainCollectionView.mj_footer endRefreshing];
}

//获取广告轮播图数据
- (void)bannerData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"4", @"position",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetFindImages parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [_bannerArr removeAllObjects];
            _bannerArr = [AEImages mj_objectArrayWithKeyValuesArray:responseData];
            [_mainCollectionView reloadData];
        }
    }];
}

//获取限时购数据
- (void)limitBuyData {
    NSDictionary *dic = [NSDictionary dictionary];
    __weak ClassifyHomeVC *weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_Xianshigou parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        
        if (status == Request_Success) {
            [_limitDic removeAllObjects];
            if([responseData isKindOfClass:[NSDictionary class]]) {
                _limitDic = responseData;
                [_mainCollectionView reloadData];
                
                // 倒计时
                taskID=  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                    [weakSelf endBack];
                }];
                showTimer =  [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    [weakSelf timeDecreasing];
                }];
                //                showTimer = [NSTimer timerWithTimeInterval:1
                //                                                    target:self
                //                                                  selector:@selector(timeDecreasing)
                //                                                  userInfo:nil
                //                                                   repeats:YES];
                //                [[NSRunLoop mainRunLoop] addTimer:showTimer forMode:NSDefaultRunLoopMode];
            }
        }
    }];
}


-(void)endBack
{
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:taskID];
    taskID = UIBackgroundTaskInvalid;
}

//获取设计师说轮播图数据
- (void)designerSayData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"5", @"position",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetFindImages parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [_designerSayArr removeAllObjects];
            _designerSayArr = [AEImages mj_objectArrayWithKeyValuesArray:responseData];
            [_mainCollectionView reloadData];
        }
    }];
}

//获取福利中心轮播图数据
- (void)welfareCenter {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"7", @"position",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetFindImages parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [_welfareCenterArr removeAllObjects];
            _welfareCenterArr = [AEImages mj_objectArrayWithKeyValuesArray:responseData];
            [_mainCollectionView reloadData];
        }
    }];
}

//获取精选专题轮播图数据
- (void)bestProjectData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"6", @"position",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetFindImages parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [_bestProjectArr removeAllObjects];
            _bestProjectArr = [AEImages mj_objectArrayWithKeyValuesArray:responseData];
            [_mainCollectionView reloadData];
        }
    }];
}

//获取好物推荐、人气新品数据
- (void)goodProductData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [Utils isUserLogin]?[UserInfo share].userID:@"-1", @"member_id",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_Get_GoodsRecommendList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            if (![Utils isBlankString:responseData]) {
                
                NSMutableArray *resultArr = [GoodsModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
                
                for (int i=0; i<resultArr.count; i++) {
                    GoodsModel *model = resultArr[i];
                    if ([model.act_id isEqualToString:@"1"]) {
                        [_productsArr addObject:model];
                    }
                    if ([model.act_id isEqualToString:@"2"]) {
                        [_goodsRecommendArr addObject:model];
                    }
                }
                
                [_mainCollectionView reloadData];
            }
        }
    }];
}

#pragma mark - Getters

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-106-49) collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
        [_mainCollectionView registerClass:[GridListCell class] forCellWithReuseIdentifier:kGridListCell]; //主cell
        [_mainCollectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BannerView"]; //图片轮播
        [_mainCollectionView registerClass:[LimitBuyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LimitBuyView"]; //限时购
        [_mainCollectionView registerClass:[DesignerSayView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DesignerSayView"]; //设计师说
        [_mainCollectionView registerClass:[WelfareCenterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCenterView"]; //福利中心
        [_mainCollectionView registerClass:[NewProductsView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProductsView"]; //人气新品
        [_mainCollectionView registerClass:[BestProjectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BestProjectView"]; //精选专题
        
        //动画下拉刷新
//        [self collectionViewGifHeaderWithRefreshingBlock:^{
//            //[self getData];
//        }];
        
    }
    return _mainCollectionView;
}

#pragma mark - 动画下拉刷新/上拉加载更多

- (void)collectionViewGifHeaderWithRefreshingBlock:(void(^)()) block {
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [refreshingImages addObject:image];
    }
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [gifHeader setImages:@[refreshingImages[0]] forState:MJRefreshStateIdle];
    [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
    [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
    _mainCollectionView.mj_header = gifHeader;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==5) {
        return _goodsRecommendArr.count;
    } else {
        return 0;
    }
}

//主cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGridListCell forIndexPath:indexPath];
    cell.isGrid = YES; //格子视图
    cell.model = self.goodsRecommendArr[indexPath.row];
    cell.collectBtn.tag = 10000+indexPath.row;
    [cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside]; //关注事件
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH - 0.5) / 2, (WIDTH - 0.5) / 2 + 60);
}

//分组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BannerView *bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BannerView" forIndexPath:indexPath];
        bannerView.bannerArr = _bannerArr;
        [bannerView setBannerBlock:^(AEImages *images){
            if (self.imageRollBlock) {
                self.imageRollBlock(images);
            }
        }];
        return bannerView;
    }
    else if (indexPath.section == 1)
    {
        LimitBuyView *limitBuyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LimitBuyView" forIndexPath:indexPath];
        limitBuyView.limitDic = _limitDic;
        if (_limitDic.count>0) {
            limitBuyView.alpha = 1;
        } else {
            limitBuyView.alpha = 0;
        }
        [limitBuyView setBuyBlock:^(NSString *webUrl){
            if(self.webBlock){
                self.webBlock(webUrl);
            }
        }];
        return limitBuyView;
    }
    else if (indexPath.section == 2)
    {
        DesignerSayView *designerSayView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DesignerSayView" forIndexPath:indexPath];
        designerSayView.dataSource = _designerSayArr;
        [designerSayView setSayBlock:^(AEImages *images){
            if (self.imageRollBlock) {
                self.imageRollBlock(images);
            }
        }];
        return designerSayView;
    }
    else if (indexPath.section == 3)
    {
        WelfareCenterView *welfareCenterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCenterView" forIndexPath:indexPath];
        welfareCenterView.dataSource = _welfareCenterArr;
        [welfareCenterView setWelfareBlock:^(AEImages *images){ //跳转原生福利中心页面
            if (self.welfareBlock) {
                self.welfareBlock();
            }
        }];
        return welfareCenterView;
    }
    else if (indexPath.section == 4)
    {
        NewProductsView *newProductsView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProductsView" forIndexPath:indexPath];
        newProductsView.dataSource = _productsArr;
        [newProductsView setDetailBlock:^(GoodsModel *goodsModel){ //原生商品详情
            if (self.detailBlock) {
                self.detailBlock(goodsModel);
            }
        }];
        return newProductsView;
    }
    else if (indexPath.section == 5)
    {
        BestProjectView *bestProjectView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BestProjectView" forIndexPath:indexPath];
        bestProjectView.dataSource = _bestProjectArr;
        [bestProjectView setProjectBlock:^(AEImages *images){
            if (self.imageRollBlock) {
                self.imageRollBlock(images);
            }
        }];
        return bestProjectView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(WIDTH, HEIGHT-106-49-145);
    }
    else if (section == 1)
    {
        return CGSizeMake(WIDTH, 145);
    }
    else if (section == 2)
    {
        return CGSizeMake(WIDTH, WIDTH/2);
    }
    else if (section == 3)
    {
        return CGSizeMake(WIDTH, 100);
    }
    else if (section == 4)
    {
        return CGSizeMake(WIDTH, WIDTH/2.5 + 130);
    }
    else if (section == 5)
    {
        return CGSizeMake(WIDTH, 50+WIDTH/2+45);
    }
    return CGSizeZero;
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *goodsModel = self.goodsRecommendArr[indexPath.row];
    if (self.detailBlock) {
        self.detailBlock(goodsModel);
    }
}

#pragma mark - 关注

- (void)collectAction:(UIButton *)button {
    
    int index = (int)button.tag-10000;
    GoodsModel *model = self.goodsRecommendArr[index];
    
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"memberID",
                             model.ID, @"gid",
                             nil];
        
        if (button.isSelected==YES) { //取消关注
            [[NetworkManager sharedManager] postJSON:URL_DeleteFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    button.selected = NO;
                    //[Utils showToast:@"取消关注"];
                }
            }];
        } else { //添加关注
            [[NetworkManager sharedManager] postJSON:URL_AddFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    button.selected = YES;
                    //[Utils showToast:@"关注成功"];
                }
            }];
        }
    } else {
        //跳到登录页面
        if (self.loginBlock) {
            self.loginBlock();
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
