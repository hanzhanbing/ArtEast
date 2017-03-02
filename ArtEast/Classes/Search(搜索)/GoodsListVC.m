//
//  GoodsListVC.m
//  ArtEast
//
//  Created by yibao on 16/10/20.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsListVC.h"
#import <MJRefresh.h>
#import "BaseWebVC.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"
#import "GoodsListCell.h"

@interface GoodsListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_dataArr;
    NSInteger _currentPage;
    DefaultView *_defaultView;
}
@end

@implementation GoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.virtual_cat_name;
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    
    [self initView];
    [self blankView];
    [self getData:_currentPage];
}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:self.tableFrame];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    _defaultView.hidden = YES;
    self.tableView.hidden = NO;
    [self getData:1];
}

- (void)getData:(NSInteger)currPage {
    
    if (currPage == 1) {
        [_dataArr removeAllObjects];
    }
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = nil;
    if (self.search_content.length>0) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%ld",(long)_currentPage], @"page",
               self.search_content, @"skey",
               nil];
    } else {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%ld",(long)_currentPage], @"page",
               self.virtual_cat_id, @"virtual_cat_id",
               nil];
    }
    [[NetworkManager sharedManager] postJSON:URL_GetGoodsList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        [JHHJView hideLoading]; //结束加载
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (status == Request_Success) {
            //[Utils showToast:@"商品列表获取成功"];
            
            if (![Utils isBlankString:responseData]) {
                NSDictionary *pagerDic = responseData[@"pager"];
                NSArray *array = (NSArray *)responseData[@"goodsData"];
                [_dataArr addObjectsFromArray:array];
                
                if (_dataArr.count==0) {
                    self.tableView.hidden = YES;
                    _defaultView.hidden = NO;
                    _defaultView.delegate = nil;
                    _defaultView.imgView.image = [UIImage imageNamed:@"NoSearchResult"];
                    _defaultView.lab.text = @"您寻找的商品还未上架";
                } else {
                    if ([pagerDic[@"pagetotal"] integerValue]==_currentPage || array.count==0) {
                        self.tableView.mj_footer = nil;
                    } else {
                        [self tableViewGifFooterWithRefreshingBlock:^{
                            [self loadMoreData];
                        }];
                    }
                    _dataSource = [GoodsModel mj_objectArrayWithKeyValuesArray:_dataArr];
                    [self.tableView reloadData];
                }
            } else {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoSearchResult"];
                _defaultView.lab.text = @"您寻找的商品还未上架";
            }
        } else {
            if (![Utils getNetStatus]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.tableView.hidden = YES;
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

- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:self.tableFrame style:UITableViewStyleGrouped];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PageColor;
    [self.view addSubview:self.tableView];
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self getData:1];
    }];
    
    //动画加载更多
    [self tableViewGifFooterWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListCellID"];
    if (!cell) {
        cell = [[GoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsListCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GoodsModel *goodsModel = _dataSource[indexPath.section];
    cell.goodsModel = goodsModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsModel *goodsModel = _dataSource[indexPath.section];
    return [GoodsListCell getHeight:goodsModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsModel *goodsModel = _dataSource[indexPath.section];
    //[BaseWebVC showWithContro:self withUrlStr:goodsModel.url withTitle:@"商品详情"];
    
    CGRect descRec = CGRectMake(0, 0, WIDTH, WIDTH); //目的位置
    
    CGRect originalRec;
    UIImageView *imageView = nil;
    GoodsListCell *firstCell = (GoodsListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    originalRec = [firstCell.imageV convertRect:firstCell.imageV.frame toView:self.view];
    originalRec = CGRectMake(originalRec.origin.x-15, originalRec.origin.y-10, originalRec.size.width, originalRec.size.height);
    imageView = firstCell.imageV;
    
    goodsModel.imageView = imageView;
    goodsModel.descRec = descRec;
    goodsModel.originalRec = originalRec;
    
    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.goodsModel = goodsModel;
    BaseNC *baseNC = (BaseNC *)self.navigationController;
    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
