//
//  AddressVC.m
//  ArtEast
//
//  Created by yibao on 16/12/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AddressVC.h"
#import "EditAddressVC.h"
#import "AddressModel.h"
#import "AddressCell.h"
#import <MJRefresh.h>

@interface AddressVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataArr;
    DefaultView *_defaultView;
    UIButton *_addAddress;
}
@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray array];
    
    [self initView]; //初始化视图
    [self blankView];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress:) name:kChangeAddresssSuccNotification object:nil]; //修改地址成功
}

//刷新地址页面
-(void)refreshAddress:(NSNotification *)noti {
    
    [self getData];
}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-80)];
    _defaultView.backgroundColor = [UIColor whiteColor];
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
                         [UserInfo share].userID, @"memberID",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_MyAddress parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        [self.tableView.mj_header endRefreshing];

        _addAddress.hidden = NO;
        
        if (status == Request_Success) {
            
            _dataArr = [AddressModel mj_objectArrayWithKeyValuesArray:responseData];
            
            //排序,默认地址排在第一位
            for (int i = 0; i<_dataArr.count; i++) {
                AddressModel *addressModel = _dataArr[i];
                if ([addressModel.def_addr isEqualToString:@"1"]) {
                    [_dataArr removeObjectAtIndex:i];
                    [_dataArr insertObject:addressModel atIndex:0];
                }
            }
            
            if (_dataArr.count==0) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoAddress"];
                _defaultView.imgView.frame = CGRectMake(WIDTH/2-34.5, 0, 69, 88);
                _defaultView.lab.text = @"收货地址在哪里";
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
                    _defaultView.imgView.frame = CGRectMake(WIDTH/2-50, 0, 100, 86.5);
                    _defaultView.lab.text = @"网络状态待提升，点击重试";
                });
            }
        }
    }];
}

#pragma mark - init view

- (void)initView {
//    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 3)];
//    topImageView.image = [UIImage imageNamed:@"AddressIcon"];
//    [self.view addSubview:topImageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-80) style:UITableViewStyleGrouped];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = AELineColor;
    [self.view addSubview:self.tableView];
    
    //新建地址
    _addAddress = [[UIButton alloc] initWithFrame:CGRectMake(15, HEIGHT-65, WIDTH-30, 50)];
    _addAddress.hidden = YES;
    _addAddress.layer.cornerRadius = 3;
    [_addAddress.layer setMasksToBounds:YES];
    _addAddress.layer.borderWidth = 1;
    _addAddress.layer.borderColor = AppThemeColor.CGColor;
    [_addAddress setTitle:@"+ 新建地址" forState:UIControlStateNormal];
    [_addAddress setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _addAddress.titleLabel.font = [UIFont systemFontOfSize:15];
    [_addAddress addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addAddress];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCellID"];
    if (!cell) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AddressModel *addressModel = _dataArr[indexPath.section];
    cell.addressModel = addressModel;
    cell.changeBtn.tag = 1000+indexPath.section;
    [cell.changeBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *addressModel = _dataArr[indexPath.section];
    return [AddressCell getHeight:addressModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.from isEqualToString:@"订单确认"]) {
        return NO;
    } else {
        return YES;
    }
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载 //开始加载
        AddressModel *addressModel = _dataArr[indexPath.section];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"memberID",
                             addressModel.addr_id, @"addr_id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_DeleteAddress parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"删除成功"];
                [self getData];
            }
        }];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.from isEqualToString:@"订单确认"]) {
        AddressModel *addressModel = _dataArr[indexPath.section];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectAddresssSuccNotification object:addressModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - methods

//添加地址
- (void)addAddress {
    if (_dataArr.count<10) {
        EditAddressVC *editAddressVC = [[EditAddressVC alloc] init];
        editAddressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editAddressVC animated:YES];
    }
    
}

//编辑地址
- (void)editAddress:(UIButton *)btn {
    int index = (int)btn.tag-1000;
    AddressModel *addressModel = _dataArr[index];
    EditAddressVC *editAddressVC = [[EditAddressVC alloc] init];
    editAddressVC.addressModel = addressModel;
    editAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
