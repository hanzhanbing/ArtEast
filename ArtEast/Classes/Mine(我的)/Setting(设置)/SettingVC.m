//
//  SettingVC.m
//  ArtEast
//
//  Created by yibao on 16/10/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "SettingVC.h"
#import <JPUSHService.h>
#import "AboutUsVC.h"
#import "FeedbackVC.h"
#import "AEFilePath.h"
#import "TestVC.h"

@interface SettingVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *cacheLab;
}

@property(nonatomic,strong)NSArray *dataList;//数据源

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    _dataList = @[@"消息推送",@"WIFI环境自动升级客户端",@"清除缓存",@"意见反馈",@"关于我们"];
    
    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"" forState:UIControlStateNormal];
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    
    [self initTab]; //创建TableView
}

- (void)test {
    TestVC *test = [[TestVC alloc] init];
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
}

#pragma mark - init view

- (void)initTab {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        
        self.tableView.tableFooterView = [self tableFooterView];
    }
}

- (UIView *)tableFooterView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, WIDTH-30, 45)];
    exitBtn.cornerRadius = 5;
    exitBtn.backgroundColor = ButtonBgColor;
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = ButtonFontSize;
    [exitBtn setTitleColor:ButtonFontColor forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitBtn];
    
    return view;
}

#pragma mark - methods

//关闭/打开推送开关
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
        }]; //绑定别名
    }else {
        [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
        }]; //清除别名
    }
}

//退出登录
- (void)exitAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"member_id",
                             nil];
        
        [[NetworkManager sharedManager] postJSON:URL_Logout parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"注销成功"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
                [[UserInfo share] setUserInfo:nil]; //清除用户信息
                
                [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    
                }]; //清除别名
                
                //环信退出登录
                EMError *err = [[EMClient sharedClient] logout:NO];
                if (!err) {
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
                self.tabBarController.selectedIndex = 2;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }])];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"settingCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //添加箭头
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]; //cell选中背景颜色
    
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = LightBlackColor;
    cell.textLabel.font = kFont14Size;
    
    if ([cell.textLabel.text isEqualToString:@"消息推送"]) {
        cell.accessoryView = [[UIView alloc] init];
        
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH-70, 10, 50, 30)];
        switchBtn.onTintColor = LightYellowColor;
        [switchBtn setOn:YES];
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchBtn];
    }
    
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cacheLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-120, 15, 100, 20)];
        cacheLab.text = [AEFilePath folderSizeAtPath:kCachePath];
        cacheLab.textAlignment = NSTextAlignmentRight;
        cacheLab.font = kFont14Size;
        cacheLab.textColor = LightBlackColor;
        [cell addSubview:cacheLab];
        cell.accessoryView = [[UIView alloc] init];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _dataList[indexPath.row];
    
    if ([title isEqualToString:@"WIFI环境自动升级客户端"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请打开设置--iTunes Store 与 App Store页面，将更新按钮开启" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
    if ([title isEqualToString:@"清除缓存"]) {
        NSString *message = [NSString stringWithFormat:@"确定清除%@缓存吗？",[AEFilePath folderSizeAtPath:kCachePath]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *files= [[NSFileManager defaultManager] subpathsAtPath:kCachePath];
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [kCachePath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils showToast:@"缓存清除完毕"];
                    [self.tableView reloadData];
                });
            });
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
    if ([title isEqualToString:@"意见反馈"]) {
        FeedbackVC *feedbackVC = [[FeedbackVC alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    
    if ([title isEqualToString:@"关于我们"]) {
        AboutUsVC *aboutUsVC = [[AboutUsVC alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
