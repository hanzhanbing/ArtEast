//
//  CouponItemVC.m
//  ArtEast
//
//  Created by zyl on 16/12/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "CouponItemVC.h"
#import "CouponModel.h"
#import "CouponCell.h"

@interface CouponItemVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataArr;
    NSMutableArray *_dataArr1; //未使用
    NSMutableArray *_dataArr2; //已使用
    NSMutableArray *_dataArr3; //已过期
    DefaultView *_defaultView;
}
@end

@implementation CouponItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    _dataArr1 = [NSMutableArray array];
    _dataArr2 = [NSMutableArray array];
    _dataArr3 = [NSMutableArray array];
    
    [self initView]; //初始化视图
    [self blankView];
    [self getData];
}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-42)];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    _defaultView.hidden = YES;
    self.tableView.hidden = NO;
    [self getData];
}

#pragma mark - init data

- (void)getData {
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"member_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_GetCoupoinList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            
            _dataArr = [CouponModel mj_objectArrayWithKeyValuesArray:responseData];
            
            //优惠券分类
            for (int i = 0; i<_dataArr.count; i++) {
                CouponModel *couponModel = _dataArr[i];
                if ([couponModel.STATUS isEqualToString:@"可使用"]) {
                    [_dataArr1 addObject:couponModel];
                }
                if ([couponModel.STATUS isEqualToString:@"已使用"]) {
                    [_dataArr2 addObject:couponModel];
                }
                if ([couponModel.STATUS isEqualToString:@"已过期"]) {
                    [_dataArr3 addObject:couponModel];
                }
            }
            
            if ([self.title isEqualToString:@"未使用"]) {
                _dataArr = _dataArr1;
            }
            if ([self.title isEqualToString:@"已使用"]) {
                _dataArr = _dataArr2;
            }
            if ([self.title isEqualToString:@"已过期"]) {
                _dataArr = _dataArr3;
            }
            
            if (_dataArr.count==0) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoCoupon"];
                _defaultView.lab.text = @"没有任何的优惠券";
            } else {
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

#pragma mark - init view

- (void)initView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-42) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCellID"];
    if (!cell) {
        cell = [[CouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CouponModel *couponModel = _dataArr[indexPath.section];
    cell.couponModel = couponModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponModel *couponModel = _dataArr[indexPath.section];
    return [CouponCell getHeight:couponModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![Utils isBlankString:self.from]) {
        CouponModel *couponModel = _dataArr[indexPath.section];
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [UserInfo share].userID, @"memberID",
                   couponModel.memc_code, @"coupon",
                   [self.from isEqualToString:@"商品详情"]?@"true":@"false", @"isfast",
                   nil];
        [[NetworkManager sharedManager] postJSON:URL_AddCoupon parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                if (self.couponBlock) {
                    if ([responseData isKindOfClass:[NSDictionary class]]) {
                        self.couponBlock(responseData);
                    }
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
