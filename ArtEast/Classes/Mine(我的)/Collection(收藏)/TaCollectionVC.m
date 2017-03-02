//
//  TaCollectionVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/14.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "TaCollectionVC.h"
#import <MJRefresh.h>
#import "AEMoreView.h"
#import "BaseWebVC.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"
#import "GoodsCollectionCell.h"

@interface TaCollectionVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataSource;
    DefaultView *_defaultView;
}
@end

@implementation TaCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ta的喜欢";
    
    [self initView];
    [self getData];
}

- (void)getData {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"memberID",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_MyFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        [JHHJView hideLoading]; //结束加载
        [self.tableView.mj_header endRefreshing];
        
        if (status == Request_Success) {
            //[Utils showToast:@"喜欢列表获取成功"];
            
            NSArray *array = (NSArray *)responseData;
            if (array.count==0) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoCollect"];
                _defaultView.lab.text = @"还没有任何喜欢呢";
            } else {
                _dataSource = [GoodsModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView reloadData];
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

- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:self.tableFrame style:UITableViewStyleGrouped];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PageColor;
    [self.view addSubview:self.tableView];
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self refresh];
    }];
    
    _defaultView = [[DefaultView alloc] initWithFrame:self.tableFrame];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    NSLog(@"点击刷新");
    self.tableView.hidden = NO;
    _defaultView.hidden = YES;
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListCellID"];
    if (!cell) {
        cell = [[GoodsCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsCollectionCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GoodsModel *goodsModel = _dataSource[indexPath.section];
    cell.goodsModel = goodsModel;
    cell.moreBtn.tag = 1000+indexPath.section;
    [cell.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsModel *goodsModel = _dataSource[indexPath.section];
    return [GoodsCollectionCell getHeight:goodsModel];
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
    GoodsCollectionCell *firstCell = (GoodsCollectionCell *)[tableView cellForRowAtIndexPath:indexPath];
    
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

#pragma mark - methods

//更多
- (void)moreAction:(UIButton *)sender {
    GoodsModel *goodsModel = _dataSource[sender.tag-1000];
    
    AEMoreView *moreView = [[AEMoreView alloc] initWithBaseController:self andBaseView:self.view];
    [moreView setButtonBlock:^(){
        NSLog(@"取消喜欢");
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"memberID",
                             goodsModel.ID, @"gid",
                             nil];
        
        [[NetworkManager sharedManager] postJSON:URL_DeleteFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"取消喜欢成功"];
                [self getData];
            }
        }];
        
    }];
    [moreView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
