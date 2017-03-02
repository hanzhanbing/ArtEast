//
//  TestVC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "TestVC.h"
#import <MJRefresh.h>
#import "AEShareView.h"
#import "AEUMengCenter.h"
#import <JPUSHService.h>
#import "ChatViewController.h"

@interface TestVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"测试";
    
    //self.isPanForbid = YES; //禁用iOS自带侧滑返回手势
    
    [self initTab];
}

#pragma mark - init view

- (void)initTab {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStyleGrouped];
    //self.tableView.tableFooterView = [[UIView alloc] init]; //不显示没内容的cell
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //正常下拉刷新
    //self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //[self.tableView.mj_header beginRefreshing];
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //动画加载更多
    [self tableViewGifFooterWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

#pragma mark - lazy loading...

- (NSArray *)dataArr {
    if(_dataArr==nil)
    {
        _dataArr = @[@"切换到线下",@"切换到Beta",@"切换到线上",@"动画弹框2",@"加载中动画",@"加载成功",@"加载失败",@"内容友盟分享",@"详情友盟分享",@"授权登录",@"仿安卓Toast提示",@"判断系统相机权限",@"判断系统照片权限",@"判断系统通讯录权限",@"判断系统麦克风权限",@"https接口测试",@"Md5加密"];
    }
    return _dataArr;
}

#pragma mark - methods

//没有网络了
- (void)netWorkDisappear
{
    [super netWorkDisappear];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

//有网络了
- (void)netWorkAppear
{
    [super netWorkAppear];
    
    [self getData];
}

//获取数据
- (void)getData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    [self.tableView reloadData];
}

//加载更多数据
- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([Utils getNetStatus]) {
        return nil;
    }
    else
    {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        header.backgroundColor = kColorFromRGBHex(0xFFBCBE);
        UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDTH -40, 40)];
        headerLab.text = @"当前网络不可用，请设置您的网络";
        headerLab.font = [UIFont systemFontOfSize:16 ];
        headerLab.textColor = kColorFromRGBHex(0x030303);
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        iconView.image = [UIImage imageNamed:@"NetNotice.png"];
        [header addSubview:iconView];
        [header addSubview:headerLab];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([Utils getNetStatus]) {
        return 0.0001;
    }
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    NSString *title = self.dataArr[indexPath.row];
    
    if ([title isEqualToString:@"切换到线下"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"ea1af2ad4527edb95ad492943b986d6d426d99381953f10465a0ce6504b62a3e" forKey:@"AppSecret"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/api" forKey:@"ProductUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/" forKey:@"WebUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/" forKey:@"PictureUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
        [[UserInfo share] setUserInfo:nil]; //清除用户信息

        exit(0);
    }
    
    if ([title isEqualToString:@"切换到Beta"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"325304c6db66dece54350ee3ace6b65ff550851f3386d3b90e25446866d315cc" forKey:@"AppSecret"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://beta.cydf.com/api" forKey:@"ProductUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://beta.cydf.com/" forKey:@"WebUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://beta.cydf.com/" forKey:@"PictureUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
        [[UserInfo share] setUserInfo:nil]; //清除用户信息
        
        exit(0);
    }
    
    if ([title isEqualToString:@"切换到线上"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"ea1af2ad4527edb95ad492943b986d6d426d99381953f10465a0ce6504b62a3e" forKey:@"AppSecret"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://www.cydf.com/api" forKey:@"ProductUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://www.cydf.com/" forKey:@"WebUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://images-app.cydf.com/" forKey:@"PictureUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
        [[UserInfo share] setUserInfo:nil]; //清除用户信息
        
        exit(0);
    }
    
    if ([title isEqualToString:@"动画弹框1"]) {
        AEAlertView *alert = [[AEAlertView alloc] initWithTitle:@"温馨提示" message:@"自定义alertview,可以自动适应文字内容。" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"点击index====%ld",(long)clickIndex);
        }];
        alert.animationStyle = ASAnimationLeftShake; //从左到右动画
        //alert.dontDissmiss = YES; //适合在强制升级时使用
        [alert showAlertView];
    }
    
    if ([title isEqualToString:@"动画弹框2"]) {
        ZBAlertView *alert = [[ZBAlertView alloc] initWithTitle:@"温馨提示" contentText:@"是否需要现在去登录" leftButtonTitle:@"不登录" rightButtonTitle:@"立即登录" baseView:self.view];
        alert.animationStyle = ASAnimationTopShake; //从上到下动画
        alert.doneBlock = ^()
        {
            NSLog(@"跳到登录界面");
        };
    }
    
    if ([title isEqualToString:@"加载中动画"]) {
        [[AEIndicator sharedIndicator] startAnimation];  //开始转动
    }
    
    if ([title isEqualToString:@"加载成功"]) {
        [[AEIndicator sharedIndicator] stopAnimationWithLoadText:@"加载成功" withType:YES];//加载成功
    }
    
    if ([title isEqualToString:@"加载失败"]) {
        [[AEIndicator sharedIndicator] stopAnimationWithLoadText:@"加载失败" withType:NO];//加载失败
    }
    
    if ([title isEqualToString:@"内容友盟分享"]) {
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:@"http://www.pptbz.com/pptpic/uploadfiles_6909/201202/2012022917310499.jpg" forKey:@"image"];
        [paramDic setObject:@"http://192.168.1.6/web/Share/contentDetails.html?article_id=300" forKey:@"url"];
        [paramDic setObject:@"友盟分享测试" forKey:@"title"];
        [paramDic setObject:@"创艺东方iOS端友盟分享测试" forKey:@"text"];
        
        AEShareView *shareView = [[AEShareView alloc] initWithBaseController:self andBaseView:self.view andData:paramDic andType:ShareUrl];
        [shareView show];
    }
    
    if ([title isEqualToString:@"详情友盟分享"]) {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:@"http://www.pptbz.com/pptpic/uploadfiles_6909/201202/2012022917310499.jpg" forKey:@"image"];
        [paramDic setObject:@"http://192.168.1.6/web/Share/goodsDetails.html?iid=5172" forKey:@"url"];
        [paramDic setObject:@"友盟分享测试" forKey:@"title"];
        [paramDic setObject:@"创艺东方iOS端友盟分享测试" forKey:@"text"];
        
        AEShareView *shareView = [[AEShareView alloc] initWithBaseController:self andBaseView:self.view andData:paramDic andType:ShareUrl];
        [shareView show];
    }
    
    if ([title isEqualToString:@"授权登录"]) {
//        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"第三方授权登录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *qqAuthAction = [UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_QQ withBaseController:self result:^(BOOL success, NSString *errorString) {
//                if (success) {
//                    DLog(@"成功");
//                } else {
//                    DLog(@"%@",errorString);
//                }
//            }];
//        }];
//        
//        UIAlertAction *weixinAuthAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_WechatSession withBaseController:self result:^(BOOL success, NSString *errorString) {
//                if (success) {
//                    DLog(@"成功");
//                } else {
//                    DLog(@"%@",errorString);
//                }
//            }];
//        }];
//        
//        UIAlertAction *sinaAuthAction = [UIAlertAction actionWithTitle:@"新浪微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_Sina withBaseController:self result:^(BOOL success, NSString *errorString) {
//                if (success) {
//                    DLog(@"成功");
//                } else {
//                    DLog(@"%@",errorString);
//                }
//            }];
//        }];
//        
//        UIAlertAction *cancelRouteAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            
//        }];
//        
//        // 添加操作（顺序就是呈现的上下顺序）
//        [alertDialog addAction:qqAuthAction];
//        [alertDialog addAction:weixinAuthAction];
//        [alertDialog addAction:sinaAuthAction];
//        [alertDialog addAction:cancelRouteAction];
//        
//        // 呈现视图
//        [self presentViewController:alertDialog animated:YES completion:nil];
    }
    
    if ([title isEqualToString:@"仿安卓Toast提示"]) {
        if (![Utils getNetStatus]) {
            [Utils showToast:@"网络不给力，请重试！"];
        } else {
            [Utils showToast:@"当前网络环境很给力！"];
        }
    }
    
    if ([title isEqualToString:@"判断系统相机权限"]) {
        if ([Utils isCameraPermissionOn]) {
            [Utils showToast:@"相机权限开启"];
        } else {
            [Utils showToast:@"相机权限关闭"];
        }
    }
    
    if ([title isEqualToString:@"判断系统照片权限"]) {
        if ([Utils isCameraPermissionOn]) {
            [Utils showToast:@"照片权限开启"];
        } else {
            [Utils showToast:@"照片权限关闭"];
        }
    }
    
    if ([title isEqualToString:@"判断系统通讯录权限"]) {
        [Utils checkAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                [Utils showToast:@"通讯录权限开启"];
            } else {
                [Utils showToast:@"通讯录权限关闭"];
            }
        }];
    }
    
    if ([title isEqualToString:@"判断系统麦克风权限"]) {
        [Utils checkMicrophoneAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                [Utils showToast:@"麦克风权限开启"];
            } else {
                [Utils showToast:@"麦克风权限关闭"];
            }
        }];
    }
    
    if ([title isEqualToString:@"https接口测试"]) {
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"18611541125", @"uname",
                             @"1234567", @"password",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            NSLog(@"%d",status);
            
            if (status == Request_Success) {
                [Utils showToast:@"登录成功"];
            } else {
                [Utils showToast:@"登录失败"];
            }
        }];
    }
    
    if ([title isEqualToString:@"Md5加密"]) {
        [Utils showToast:[Utils md5HexDigest:@"admin"]];
        DLog(@"%@",[Utils md5HexDigest:@"admin你好1234567890#@*123"]);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.navBar.hidden = YES; //隐藏导航条
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
