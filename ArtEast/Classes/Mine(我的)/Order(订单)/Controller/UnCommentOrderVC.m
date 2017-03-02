//
//  UnCommentOrderVC.m
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UnCommentOrderVC.h"
#import <MJRefresh.h>
#import "OrderModel.h"
#import "OrderBaseCell.h"
#import "OrderCellFactory.h"
#import "DefaultView.h"

@interface UnCommentOrderVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>

@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,retain) DefaultView *defaultView;

@end

@implementation UnCommentOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待评价";
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    
    [self initView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    [self getData:1];
}

#pragma mark - init data

- (void)getData:(NSInteger)currPage {
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (currPage == 1) {
        [_dataArr removeAllObjects];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"member_id",
                         [NSString stringWithFormat:@"%ld",(long)currPage], @"n_page",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_MyUnCommentOrder parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
       
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (status == Request_Success) {
            
            if (![Utils isBlankString:responseData]) {
                NSDictionary *pagerDic = responseData[@"pager"];
                NSArray *array = (NSArray *)responseData[@"list"];
                [_dataArr addObjectsFromArray:array];
                
                if (_dataArr.count!=0) {
                    if ([pagerDic[@"total"] integerValue]==_currentPage || array.count==0) {
                        self.tableView.mj_footer = nil;
                    } else {
                        [self tableViewGifFooterWithRefreshingBlock:^{
                            [self loadMoreData];
                        }];
                    }
                    _dataSource = [OrderModel mj_objectArrayWithKeyValuesArray:_dataArr];
                } else {
                    _tableView.tableFooterView = _defaultView;
                    _defaultView.delegate = nil;
                    _defaultView.imgView.image = [UIImage imageNamed:@"NoOrder"];
                    _defaultView.lab.text = @"还没有相关的订单呢";
                    [_dataSource removeAllObjects];
                }
            } else {
                _tableView.tableFooterView = _defaultView;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoOrder"];
                _defaultView.lab.text = @"还没有相关的订单呢";
                [_dataSource removeAllObjects];
            }
        } else {
            if (![Utils getNetStatus]) {
                _tableView.tableFooterView = _defaultView;
                _defaultView.delegate = self;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
                _defaultView.lab.text = @"网络状态待提升，点击重试";
                [_dataSource removeAllObjects];
            }
        }
        
        [self.tableView reloadData];
    }];
}

//加载更多数据
- (void)loadMoreData {
    _currentPage++;
    [self getData:_currentPage];
}

#pragma mark - init view
- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-106) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-106)];
    _defaultView.delegate = self;
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self refresh];
    }];
    
    //动画加载更多
    [self tableViewGifFooterWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

#pragma mark - 动画下拉刷新/上拉加载更多
- (void)tableViewGifHeaderWithRefreshingBlock:(void(^)()) block {
    
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
    _tableView.mj_header = gifHeader;
}

- (void)tableViewGifFooterWithRefreshingBlock:(void(^)()) block {
    
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
    _tableView.mj_footer = gifFooter;
}

#pragma mark - UITableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *orderModel = _dataSource[indexPath.section];
    return [OrderCellFactory getCellHeight:orderModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *orderModel = _dataSource[indexPath.section];
    
    //编译时、运行时
    NSString *cellIndentifier = [OrderCellFactory getCellIdentifier:orderModel];
    OrderBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!baseCell) {
        baseCell = [OrderCellFactory getCell:orderModel withCellStyle:UITableViewCellStyleDefault withCellIdentifier:cellIndentifier];
    }
    
    [baseCell setContentView:orderModel];
    
    baseCell.delegate = self;
    
    return baseCell;
}

//商品详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *orderModel = _dataSource[indexPath.section];
    
    if (self.detailBlock) {
        GoodsModel *goodsModel = [[GoodsModel alloc] init];
        
        CGRect descRec = CGRectMake(0, 0, WIDTH, WIDTH); //目的位置
        
        CGRect originalRec;
        UIImageView *imageView = nil;
        OrderBaseCell *firstCell = (OrderBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        originalRec = [firstCell.goodsImg convertRect:firstCell.goodsImg.frame toView:self.view];
        originalRec = CGRectMake(originalRec.origin.x-16, originalRec.origin.y+86, originalRec.size.width, originalRec.size.height);
        imageView = firstCell.goodsImg;
        
        goodsModel.ID = orderModel.goods_id;
        goodsModel.icon = orderModel.thumbnail_pic_src;
        goodsModel.imageView = imageView;
        goodsModel.descRec = descRec;
        goodsModel.originalRec = originalRec;
        
        self.detailBlock(goodsModel);
    }
}

#pragma mark - OrderDelegate

//去评价
- (void)clickCommentOrder:(OrderModel *)order {
    NSLog(@"去评价：%@",order);
    if (self.commentBlock) {
        self.commentBlock(order);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
