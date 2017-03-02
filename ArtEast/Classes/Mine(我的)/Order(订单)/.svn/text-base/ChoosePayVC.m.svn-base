//
//  ChoosePayVC.m
//  ArtEast
//
//  Created by yibao on 16/11/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ChoosePayVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "OrderVC.h"
#import "PayResultVC.h"

@interface ChoosePayVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *iconArr;

@end

@implementation ChoosePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择付款方式";
    
    self.titleArr =  @[@"支付宝支付", @"微信支付"];
    self.iconArr =  @[@"Zhifubao", @"Weixin"];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:@"PayFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:@"PayCancel" object:nil];
}

//支付成功
- (void)paySuccess {
    PayResultVC *payResultVC = [[PayResultVC alloc] init];
    payResultVC.isSuccess = YES;
    [self.navigationController pushViewController:payResultVC animated:YES];
}

//支付失败
- (void)payFail {
    PayResultVC *payResultVC = [[PayResultVC alloc] init];
    payResultVC.isSuccess = NO;
    [self.navigationController pushViewController:payResultVC animated:YES];
}

//支付取消
-(void)payCancel {
    [Utils showToast:@"支付取消"];
}

#pragma mark - init view 

- (void)initView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 98) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 返回调到订单详情

- (void)backAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认要放弃付款？" message:@"订单会保留一段时间，请尽快支付" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.fromFlag isEqualToString:@"跳转"]) {
            OrderVC *orderVC = [[OrderVC alloc] init];
            orderVC.currentPage = 1;
            orderVC.fromFlag = @"跳转";
            [self.navigationController pushViewController:orderVC animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }])];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:_iconArr[indexPath.row]];
    
    cell.textLabel.textColor = LightBlackColor;
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self alipay]; //支付宝支付
        }
            break;
        case 1:
        {
            [self wxpay]; //微信支付
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 支付宝支付

- (void)alipay {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"memberID",
                         self.order.ID, @"payment_order_id",
                         @"malipay", @"payment_pay_app_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_OrderPay parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            
            //应用注册scheme,在ArtEast-Info.plist定义URL types
            NSString *appScheme = @"ArtEast";
            NSString *signedStr = responseData[@"sign"];

            if (![Utils isBlankString:signedStr]) {
                
                [[AlipaySDK defaultService] payOrder:signedStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSInteger status=[resultDic[@"resultStatus"] integerValue];
                    
                    switch (status) {
                        case 9000:
                            [self paySuccess];
                            break;
                            
                        case 8000:
                            [Utils showToast:@"订单正在处理中"];
                            break;
                            
                        case 4000:
                            [self payFail];
                            break;
                            
                        case 6001:
                            [self payCancel];
                            break;
                            
                        case 6002:
                            [Utils showToast:@"网络连接出错"];
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        }
    }];
}

#pragma mark - 微信支付

- (void)wxpay
{
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi]) {
        [Utils showToast:@"您未安装微信客户端，请安装微信以完成支付"];
    } else {
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"memberID",
                             self.order.ID, @"payment_order_id",
                             @"wxpay", @"payment_pay_app_id",
                             @"wx8f86c08f17287606", @"openid",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_OrderPay parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                if ([responseData isKindOfClass:[NSDictionary class]]) {
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = responseData[@"appid"];
                    req.partnerId           = responseData[@"partnerid"];
                    req.prepayId            = responseData[@"prepayid"];
                    req.nonceStr            = responseData[@"noncestr"];
                    NSMutableString *stamp  = responseData[@"timestamp"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = responseData[@"package1"];
                    req.sign                = responseData[@"sign"];
                    [WXApi sendReq:req];
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
