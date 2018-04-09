//
//  WelfareCenterVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/23.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "WelfareCenterVC.h"
#import "LoginVC.h"
#import "CouponCell.h"

@interface WelfareCenterVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataArr;
    DefaultView *_defaultView;
}
@end

@implementation WelfareCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"福利中心";
    
    _dataArr = [NSMutableArray array];
    
    [self initView]; //初始化视图
    [self blankView];
    [self getData];
}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH)];
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
                         [Utils isUserLogin]?[UserInfo share].userID:@"-1", @"member_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Get_CoupoinList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            
            [_dataArr removeAllObjects];
            _dataArr = [CouponModel mj_objectArrayWithKeyValuesArray:responseData];
            
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
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableFrame style:UITableViewStyleGrouped];
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
    
    if ([Utils isUserLogin]) {
        CouponModel *couponModel = _dataArr[indexPath.section];
        
        if ([couponModel.isget isEqualToString:@"0"]) { //未领取
            [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserInfo share].userID, @"member_id",
                                 couponModel.cpns_id, @"cpns_id",
                                 nil];
            [[NetworkManager sharedManager] postJSON:URL_User_Get_Coupoin parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                [JHHJView hideLoading]; //结束加载
                
                if (status == Request_Success) {
                    [self getData];
                }
            }];
        }
    } else {
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
