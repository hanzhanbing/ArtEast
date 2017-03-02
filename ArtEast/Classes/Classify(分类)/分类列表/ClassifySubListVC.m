//
//  ClassifySubListVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/19.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ClassifySubListVC.h"
#import "GridListCell.h"
#import <MJRefresh.h>
#import "GoodsModel.h"
#import "AETypeInfo.h"

@interface ClassifySubListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshDelegate>

@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) DefaultView *defaultView;

@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation ClassifySubListVC

#pragma mark - Getters

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0.5 , WIDTH, HEIGHT - 106 - 0.5) collectionViewLayout:flowlayout];
        _collectionView.alpha = 0;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        //注册cell
        [_collectionView registerClass:[GridListCell class] forCellWithReuseIdentifier:kGridListCell];
        
        //动画下拉刷新
        [self collectionViewGifHeaderWithRefreshingBlock:^{
            _currentPage = 1;
            [self getData:1];
        }];
        
        //动画加载更多
        [self collectionViewGifFooterWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.typeInfo.virtual_cat_name;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05];
    
    //默认格子视图
    _isGrid = YES;
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    
    [self initView];
    
    [self blankView];
    
    [self getData:_currentPage];
}

//刷新关注图标状态
-(void)changeCollectState:(NSDictionary *)dic {
    
    NSIndexPath *indexPath = dic[@"IndexPath"];
    NSString *praiseFlag = dic[@"PraiseFlag"];
    
    GridListCell *cell = (GridListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    GoodsModel *goodsModel = self.dataSource[indexPath.row];
    
    if ([praiseFlag isEqualToString:@"0"]) {
        goodsModel.favoroite = @"0";
    }
    if ([praiseFlag isEqualToString:@"1"]) {
        goodsModel.favoroite = @"1";
    }
    
    cell.model = goodsModel;
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - init view

- (void)initView {
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = kColorFromRGBHex(0xe6e6e6);
    [self.view addSubview:lineView];
    
    //商品列表
    [self.view addSubview:self.collectionView];
}

#pragma mark - get data

- (void)getData:(NSInteger)currPage {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%ld",(long)_currentPage], @"page",
                         self.typeInfo.virtual_cat_id, @"virtual_cat_id",
                         [UserInfo share].userID, @"member_id",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_GetGoodsList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        
        if (status == Request_Success) {
            //[Utils showToast:@"商品列表获取成功"];
            
            if (currPage == 1) {
                [_dataArr removeAllObjects];
                [_dataSource removeAllObjects];
            }
            
            if (![Utils isBlankString:responseData]) {
                NSDictionary *pagerDic = responseData[@"pager"];
                NSArray *array = (NSArray *)responseData[@"goodsData"];
                [_dataArr addObjectsFromArray:array];
                
                if (_dataArr.count==0) {
                    _collectionView.hidden = YES;
                    _defaultView.hidden = NO;
                    _defaultView.delegate = nil;
                    _defaultView.imgView.image = [UIImage imageNamed:@"NoSearchResult"];
                    _defaultView.lab.text = @"您寻找的商品还未上架";
                } else {
                    if ([pagerDic[@"pagetotal"] integerValue]==_currentPage || array.count==0) {
                        _collectionView.mj_footer = nil;
                    } else {
                        [self collectionViewGifFooterWithRefreshingBlock:^{
                            [self loadMoreData];
                        }];
                    }
                    _dataSource = [GoodsModel mj_objectArrayWithKeyValuesArray:_dataArr];
                    [_collectionView reloadData];
                    
                    [UIView animateWithDuration:1 animations:^{
                        _collectionView.alpha = 1;
                    }];
                }
            } else {
                _collectionView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoSearchResult"];
                _defaultView.lab.text = @"您寻找的商品还未上架";
            }
        } else {
            if (![Utils getNetStatus]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _collectionView.hidden = YES;
                    _defaultView.hidden = NO;
                    _defaultView.delegate = self;
                    _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
                    _defaultView.lab.text = @"网络状态待提升，点击重试";
                });
            }
        }
    }];
}

//加载更多数据
- (void)loadMoreData {
    _currentPage++;
    [self getData:_currentPage];
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
    _collectionView.mj_header = gifHeader;
}

- (void)collectionViewGifFooterWithRefreshingBlock:(void(^)()) block {
    
    NSMutableArray *footerImages = [NSMutableArray array];
    for (int i = 1; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [footerImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //上拉加载需要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    //gifFooter.stateLabel.hidden = YES;
    //gifFooter.refreshingTitleHidden = YES;
    
    [gifFooter setImages:@[footerImages[0]] forState:MJRefreshStateIdle];
    [gifFooter setImages:footerImages forState:MJRefreshStateRefreshing];
    _collectionView.mj_footer = gifFooter;
}

#pragma mark - UICollectionView 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGridListCell forIndexPath:indexPath];
    cell.isGrid = _isGrid;
    cell.model = self.dataSource[indexPath.row];
    cell.collectBtn.tag = 10000+indexPath.row;
    [cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside]; //关注事件
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid) {
        return CGSizeMake((WIDTH - 0.5) / 2, (WIDTH - 0.5) / 2 + 60);
    } else {
        return CGSizeMake(WIDTH - 4, (WIDTH - 6) / 4 + 20);
    }
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
    GoodsModel *goodsModel = self.dataSource[indexPath.row];
    if (self.detailBlock) {
        
        CGRect descRec = CGRectMake(0, 0, WIDTH, WIDTH); //目的位置
        
        CGRect originalRec;
        UIImageView *imageView = nil;
        GridListCell *firstCell = (GridListCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        originalRec = [firstCell.imageV convertRect:firstCell.imageV.frame toView:self.view];
        originalRec = CGRectMake(originalRec.origin.x-30, originalRec.origin.y+86, originalRec.size.width, originalRec.size.height);
        imageView = firstCell.imageV;
        
        goodsModel.imageView = imageView;
        goodsModel.descRec = descRec;
        goodsModel.originalRec = originalRec;
        goodsModel.indexPath = indexPath;
        goodsModel.from = @"分类列表";
        goodsModel.index = self.index;
        
        self.detailBlock(goodsModel);
    }
}

#pragma mark - 关注

- (void)collectAction:(UIButton *)button {
    
    int index = (int)button.tag-10000;
    GoodsModel *model = self.dataSource[index];
    
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

#pragma mark - 网络判断

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 0.5, WIDTH, HEIGHT-106-0.5)];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    _defaultView.hidden = YES;
    _collectionView.hidden = NO;
    [self getData:1];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
