//
//  AboutUsVC.m
//  ArtEast
//
//  Created by yibao on 16/10/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AboutUsVC.h"
#import "BaseWebVC.h"
#import "AEUpdateView.h"

@interface AboutUsVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)UIImageView *logoImageView; //logo

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    self.titleArr =  @[@"用户协议", @"当前版本号"];
    
    [self rootView];
    
}

- (void)rootView
{
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginLogo"]];
    _logoImageView.frame = CGRectMake(WIDTH/2-45, 120, 90, 90);
    [self.view addSubview:_logoImageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame)+70, WIDTH, 100) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 20)];
    tipLab.text = @"COPYRIGHT*2014-2017 北京艺宝网络文化有限公司";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = PlaceHolderColor;
    tipLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipLab];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = LineColor;
    
    cell.textLabel.textColor = LightBlackColor;
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.row == 1) {
        //获取app当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
        
        cell.detailTextLabel.text = currentVersion;
        cell.detailTextLabel.textColor = LightBlackColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //[Utils showToast:@"用户协议"];
        }
            break;
        case 1:
        {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"2", @"version_type",
//                                 nil];
//            
//            [[NetworkManager sharedManager] postJSON:URL_VersionUpdate parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
//                if (status == Request_Success) {
//                    if ([responseData isKindOfClass:[NSDictionary class]]) {
//                        //新版本
//                        NSString *newVersion = responseData[@"version_number"];
//                        //获取本地app当前版本号
//                        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//                        NSString *currentVersion = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
//                        
//                        if (![newVersion isEqualToString:currentVersion]) {
//                            NSArray *textArr = [responseData[@"version_content"] componentsSeparatedByString:@";"];
//                            
//                            AEUpdateView *alert = [[AEUpdateView alloc] initWithImage:[UIImage imageNamed:@"UpdateBg"] versionText:responseData[@"version_number"] contentText:textArr leftButtonTitle:@"以后再说" rightButtonTitle:@"App Store"];
//                            alert.animationStyle = ASAnimationTopShake; //从上到下动画
//                            if ([responseData[@"update_type"] isEqualToString:@"2"]) {
//                                alert.dontDissmiss = YES; //强制更新
//                            }
//                            alert.doneBlock = ^()
//                            {
//                                NSLog(@"跳到AppStore");
//                                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:responseData[@"version_download"]]]) {
//                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseData[@"version_download"]]];
//                                }
//                            };
//                        } else {
//                            [Utils showToast:@"已是最新版本"];
//                        }
//                    }
//                }
//            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
