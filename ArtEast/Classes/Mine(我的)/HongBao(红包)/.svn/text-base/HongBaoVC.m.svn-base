//
//  HongBaoVC.m
//  ArtEast
//
//  Created by yibao on 2017/1/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "HongBaoVC.h"
#import "HongBaoCell.h"
#import "HongBaoModel.h"
#import "PPCounter.h"

@interface HongBaoVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UIView *tableHeaderView; //头视图
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) DefaultView *defaultView;

@end

@implementation HongBaoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES; //隐藏导航条
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"红包";
    
    [self.view addSubview:[self tableHeaderView]];
    [self initTab];
    [self blankView];
    [self getData];
}

#pragma mark - init view

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 64+WIDTH/3, WIDTH, HEIGHT-64-WIDTH/3)];
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

- (void)initTab {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+WIDTH/3, WIDTH, HEIGHT-64-WIDTH/3) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
    }
    //[self.tableView setTableHeaderView:[self tableHeaderView]];
}

#pragma mark - lazy loading...

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/3+64)];
        _tableHeaderView.backgroundColor = AppThemeColor;
        
        //返回
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
        [backBtn setImage:[UIImage imageNamed:@"WhiteBack"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:backBtn];
        
        //标题
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, WIDTH, 42)];
        titleLab.text = @"红包";
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:titleLab];
        
        //金钱
        _moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 54, WIDTH, WIDTH/3)];
        //_moneyLab.text=[NSString stringWithFormat:@"%@元",[UserInfo share].red_packets];
        _moneyLab.font = [UIFont boldSystemFontOfSize:30];
        _moneyLab.textColor=[UIColor whiteColor];
        _moneyLab.textAlignment=NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_moneyLab];
        
        // 设置动画类型
        _moneyLab.animationOptions = PPCounterAnimationOptionCurveEaseInOut;
        
        NSString *allMoney = [UserInfo share].red_packets;
        // 开始计数
        [_moneyLab pp_fromNumber:0 toNumber:[allMoney floatValue] duration:1.5f format:^NSString *(CGFloat number) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.positiveFormat = @"###,##0.00";
            NSNumber *amountNumber = [NSNumber numberWithFloat:number];
            return [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:amountNumber]];
        }];
    }
    return _tableHeaderView;
}

//获取数据
- (void)getData {
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"memberID",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_GetHongBaoList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载

        if (status == Request_Success) {
            _dataArr = [HongBaoModel mj_objectArrayWithKeyValuesArray:responseData];
            
            if (_dataArr.count==0) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoCoupon"];
                _defaultView.lab.text = @"暂无红包记录";
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

#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HongBaoModel *hongBaoModel = _dataArr[indexPath.section];
    return [HongBaoCell getHeight:hongBaoModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    HongBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HongBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.hongBaoModel = _dataArr[indexPath.row];
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
