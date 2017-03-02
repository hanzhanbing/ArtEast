//
//  MineVC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "MineVC.h"
#import "SettingVC.h"
#import "UMMobClick/MobClick.h"
#import "PersonalInfoVC.h"
#import "OrderVC.h"
#import "RegisterForgetPswVC.h"
#import "CollectionVC.h"
#import "HelpVC.h"
#import "BaseWebVC.h"
#import "UIImage+Color.h"
#import "ContactUsVC.h"
#import "ChatViewController.h"
#import "BindingMobileVC.h"
#import "LoginVC.h"
#import "AEFilePath.h"
#import "AddressVC.h"
#import "CouponVC.h"
#import "HongBaoVC.h"
#import <HyphenateLite/EMConversation.h>

@interface MineVC ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    //头部背景图
    UIImageView *_bgImg;
    //设置
    UIButton *_settingBtn;
    //头像
    UIImageView *_headerImg;
    //昵称
    UILabel *_nickLabel;
    
    NSString *headImgPath;
    
    //头部背景图宽高
    float _bgImgWidth;
    float _bgImgHeight;
    
    //
    //可用优惠券数量
    NSString *couponCount;
    //订单数量字典
    NSDictionary *orderCountDic;
}
@property(nonatomic,strong)NSArray *dataList;//数据源
@property(nonatomic,strong)UIView *tableHeaderView; //头视图

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    
    [MobClick event:@"Mine"]; //自定义事件统计
    
    orderCountDic = [NSDictionary dictionary];
    
    [self initData];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucc:) name:kLoginSuccNotification object:nil]; //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucc:) name:kLogoutSuccNotification object:nil]; //注销成功
}

-(void)loginSucc:(NSNotification *)noti {
    
    [self getData];
}

-(void)logoutSucc:(NSNotification *)noti {
    //跳到登录页面
//    LoginVC *loginVC = [[LoginVC alloc] init];
//    loginVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - init view

- (void)initView {
    
    //背景
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/2)]; //图片的宽度设为屏幕的宽度，高度自适应
    _bgImg.image=[UIImage imageNamed:@"MineBg"];
    //_bgImg.backgroundColor = AppThemeColor;
    _bgImg.userInteractionEnabled=YES;
    [self.view addSubview:_bgImg];
    
    _bgImgWidth=_bgImg.frame.size.width;
    _bgImgHeight=_bgImg.frame.size.height;
    
    //创建TableView
    [self initTab];
    
    //右购物车
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingBtn setImage:[UIImage imageNamed:@"Setting"] forState:UIControlStateNormal];
    _settingBtn.frame = CGRectMake(WIDTH-46, 26, 30, 30);
    _settingBtn.userInteractionEnabled = NO;
    [self.view addSubview:_settingBtn];
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-55, 20, 50, 50)];
    [setBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
}

- (void)initTab {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
    }
    [self.tableView setTableHeaderView:[self tableHeaderView]];
}

#pragma mark - init data

//网络数据
- (void)getData {
    //个人信息
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"member_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_GetPersonalInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] mutableCopy];
            [userDic setValue:responseData[@"b_year"] forKey:@"b_year"];
            [userDic setValue:responseData[@"b_month"] forKey:@"b_month"];
            [userDic setValue:responseData[@"b_day"] forKey:@"b_day"];
            [userDic setValue:responseData[@"sex"] forKey:@"sex"];
            [userDic setValue:responseData[@"name"] forKey:@"nick"];
            [userDic setValue:responseData[@"mobile"] forKey:@"mobile"];
            [userDic setValue:responseData[@"avatar"] forKey:@"avatar"];
            [userDic setValue:responseData[@"member_id"] forKey:@"member_id"];
            [userDic setValue:responseData[@"red_packets"] forKey:@"red_packets"];
            [userDic setValue:responseData[@"login_account"] forKey:@"login_account"];
            [[UserInfo share] setUserInfo:userDic];
            
            NSLog(@"yjyukiuki%@\n%@",responseData[@"avatar"],[UserInfo share].avatar);
            [_headerImg sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"MineHeadIcon"]];
            _nickLabel.text=[Utils isUserLogin]?[UserInfo share].userName:@"官人,请登录";
            
            [self.tableView reloadData];
        }
    }];
    
    //可用优惠券数量
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"memberID",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_CouponCount parameters:dic1 imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            couponCount = responseData;
            [self.tableView reloadData];
        }
    }];
    
    //订单数量
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserInfo share].userID, @"member_id",
                          nil];
    [[NetworkManager sharedManager] postJSON:URL_OrderCount parameters:dic2 imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                orderCountDic = responseData;
                [self.tableView reloadData];
            }
        }
    }];
}

//本地数据
- (void)initData {
    
    NSMutableDictionary *myOrder = [NSMutableDictionary dictionary];
    myOrder[@"title"] = @"我的订单";
    myOrder[@"icon"] = @"";
    
    NSMutableDictionary *waitPay = [NSMutableDictionary dictionary];
    waitPay[@"title"] = @"待付款";
    waitPay[@"icon"] = @"WaitPay";
    
    NSMutableDictionary *waitFaHuo = [NSMutableDictionary dictionary];
    waitFaHuo[@"title"] = @"待发货";
    waitFaHuo[@"icon"] = @"WaitFahuo";
    
    NSMutableDictionary *doneFaHuo = [NSMutableDictionary dictionary];
    doneFaHuo[@"title"] = @"已发货";
    doneFaHuo[@"icon"] = @"DoneFahuo";
    
    NSMutableDictionary *waitComment = [NSMutableDictionary dictionary];
    waitComment[@"title"] = @"待评价";
    waitComment[@"icon"] = @"Comment";
    
    NSMutableDictionary *collect = [NSMutableDictionary dictionary];
    collect[@"title"] = @"我的喜欢";
    collect[@"icon"] = @"Collect";
    
    NSMutableDictionary *coupon = [NSMutableDictionary dictionary];
    coupon[@"title"] = @"优惠券";
    coupon[@"icon"] = @"Coupon";
    
    NSMutableDictionary *hongBao = [NSMutableDictionary dictionary];
    hongBao[@"title"] = @"红包";
    hongBao[@"icon"] = @"HongBao";
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    address[@"title"] = @"地址管理";
    address[@"icon"] = @"Address";
    
    NSMutableDictionary *changePsw = [NSMutableDictionary dictionary];
    changePsw[@"title"] = @"修改密码";
    changePsw[@"icon"] = @"ChangePsw";
    
    NSMutableDictionary *onlineService = [NSMutableDictionary dictionary];
    onlineService[@"title"] = @"在线客服";
    onlineService[@"icon"] = @"OnlineService";
    
    NSMutableDictionary *help = [NSMutableDictionary dictionary];
    help[@"title"] = @"帮助中心";
    help[@"icon"] = @"Help";
    
    NSArray *orderArr = @[waitPay, waitFaHuo, doneFaHuo, waitComment];
    NSArray *section1 = @[myOrder, orderArr];
    NSArray *section2 = @[hongBao,coupon];
    NSArray *section3 = @[collect, address,changePsw];
    NSArray *section4 = @[onlineService, help];
    
    _dataList = [NSArray arrayWithObjects:section1, section2, section3,section4, nil];
}

#pragma mark - lazy loading...

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/2-1)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCover)];
        [_tableHeaderView addGestureRecognizer:tap1];
        //头像
        _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-32.5, (_tableHeaderView.height-95)/2+20, 65, 65)];
        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:32.5];
        _headerImg.backgroundColor=[UIColor whiteColor];
        _headerImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_headerImg addGestureRecognizer:tap];
        [_headerImg setImage:[UIImage imageNamed:@"MineHeadIcon"]];
        [_tableHeaderView addSubview:_headerImg];
        //昵称
        _nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-100, _headerImg.maxY+15, 200, 15)];
        _nickLabel.text=[Utils isUserLogin]?[UserInfo share].userName:@"官人,请登录";
        _nickLabel.font = [UIFont boldSystemFontOfSize:14];
        _nickLabel.textColor=[UIColor whiteColor];
        _nickLabel.textAlignment=NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_nickLabel];
    }
    return _tableHeaderView;
}

#pragma mark - methods

//修改封面
- (void)changeCover {
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
//    [sheet showInView:self.view];
}

//进入设置
- (void)settingClick {
    NSLog(@"进入设置");
    SettingVC *settingVC = [[SettingVC alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

//头像点击事件
- (void)tapClick:(UITapGestureRecognizer *)recognizer{
    NSLog(@"进入个人中心");
    PersonalInfoVC *personalInfoVC = [[PersonalInfoVC alloc] init];
    personalInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

//四种订单点击事件
- (void)orderTap:(UITapGestureRecognizer *)gesture{
    UIView *clickView = gesture.view;
    int index = (int)clickView.tag-1000;
    OrderVC *orderVC = [[OrderVC alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    orderVC.currentPage = index+1;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section!=0) {
        return 10;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0&&indexPath.row==1) {
        return 70;
    } else {
        if (HEIGHT==736) { //plus
            return 55;
        } else {
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"mineCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //添加箭头
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]; //cell选中背景颜色

    if (indexPath.section==0&&indexPath.row==1) { //四种订单状态
        cell.accessoryView = [[UIView alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *array = self.dataList[indexPath.section][indexPath.row];
        
        int count = (int)array.count;
        
        for (int i = 0; i<count; i++) {
            
            NSDictionary *dict = array[i];
            
            //背景
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/count*i, 0, WIDTH/count, 70)];
            bgView.tag = 1000+i;
            [cell addSubview:bgView];
            
            //点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap:)];
            [bgView addGestureRecognizer:tap];
            
            //图标
            UIButton *icon = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/count/2-11, 12, 22, 22)];
            [icon setBackgroundImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
            icon.userInteractionEnabled = NO;
            [bgView addSubview:icon];
            
            //数量提示
//            UIButton *iconNum = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/count/2+5, 10, 16, 16)];
//            iconNum.hidden = YES;
//            iconNum.backgroundColor = [UIColor whiteColor];
//            iconNum.titleLabel.font = kFont10Size;
//            [iconNum setTitleColor:AppThemeColor forState:UIControlStateNormal];
//            iconNum.layer.cornerRadius = 8;
//            iconNum.layer.borderColor = AppThemeColor.CGColor;
//            iconNum.layer.borderWidth = 1;
//            iconNum.userInteractionEnabled = NO;
//            [bgView addSubview:iconNum];
            
            UIButton *iconNum = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/count/2+3, 8, 18, 18)];
            iconNum.hidden = YES;
            iconNum.backgroundColor = LightYellowColor;
            iconNum.titleLabel.font = [UIFont systemFontOfSize:10];
            [iconNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            iconNum.layer.cornerRadius = 9;
            iconNum.userInteractionEnabled = NO;
            [bgView addSubview:iconNum];
            
            switch (i) {
                case 0:
                {
                    NSString *nopay = [NSString stringWithFormat:@"%@",orderCountDic[@"nopay"]];
                    if (![nopay isEqualToString:@"0"]&&![Utils isBlankString:nopay]) {
                        iconNum.hidden = NO;
                        [iconNum setTitle:nopay forState:UIControlStateNormal];
                    }
                }
                    break;
                case 1:
                {
                    NSString *noship = [NSString stringWithFormat:@"%@",orderCountDic[@"noship"]];
                    if (![noship isEqualToString:@"0"]&&![Utils isBlankString:noship]) {
                        iconNum.hidden = NO;
                        [iconNum setTitle:noship forState:UIControlStateNormal];
                    }
                }
                    break;
                case 2:
                {
                    NSString *shiping = [NSString stringWithFormat:@"%@",orderCountDic[@"shiping"]];
                    if (![shiping isEqualToString:@"0"]&&![Utils isBlankString:shiping]) {
                        iconNum.hidden = NO;
                        [iconNum setTitle:shiping forState:UIControlStateNormal];
                    }
                }
                    break;
                case 3:
                {
                    NSString *nodiscuss = [NSString stringWithFormat:@"%@",orderCountDic[@"nodiscuss"]];
                    if (![nodiscuss isEqualToString:@"0"]&&![Utils isBlankString:nodiscuss]) {
                        iconNum.hidden = NO;
                        [iconNum setTitle:nodiscuss forState:UIControlStateNormal];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            if ([iconNum.titleLabel.text integerValue]>99) {
                [iconNum setTitle:@"99+" forState:UIControlStateNormal];
                iconNum.frame = CGRectMake(WIDTH/count/2+5, 10, 20, 20);
                iconNum.layer.cornerRadius = 10;
            }
            
            //文字
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+5, WIDTH/count, 20)];
            lab.font = kFont14Size;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = dict[@"title"];
            lab.textColor = LightBlackColor;
            [bgView addSubview:lab];
            
            //分割线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/count+0.5, 10, 0.5, 50)];
            line.backgroundColor = [UIColor grayColor];
            line.alpha = 0.5;
            [bgView addSubview:line];
        }
        
    } else {
        NSDictionary *dict = self.dataList[indexPath.section][indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.textLabel.textColor = LightBlackColor;
        cell.textLabel.font = kFont14Size;
        cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 16, 16)];
//        imageView.image = [UIImage imageNamed:dict[@"icon"]];
//        [cell addSubview:imageView];
//        
//        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX+15, 17, 200, 16)];
//        lable.text = dict[@"title"];
//        lable.textColor = LightBlackColor;
//        lable.font = kFont14Size;
//        [cell addSubview:lable];
    }
    
    if ([cell.textLabel.text isEqualToString:@"优惠券"]) {
        if (![Utils isBlankString:couponCount]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@张",couponCount];
        }
        cell.detailTextLabel.font = kFont14Size;
        cell.detailTextLabel.textColor = LightBlackColor;
    }
    
    if ([cell.textLabel.text isEqualToString:@"红包"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",[UserInfo share].red_packets];
        cell.detailTextLabel.font = kFont14Size;
        cell.detailTextLabel.textColor = LightBlackColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _dataList[indexPath.section][indexPath.row][@"title"];
    
    if ([title isEqualToString:@"我的订单"]) {
        OrderVC *orderVC = [[OrderVC alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        orderVC.currentPage = 0;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    
    if ([title isEqualToString:@"我的喜欢"]) {
        CollectionVC *collectionVC = [[CollectionVC alloc] init];
        collectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
    
    if ([title isEqualToString:@"红包"]) {
        HongBaoVC *hongBaoVC = [[HongBaoVC alloc] init];
        hongBaoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hongBaoVC animated:YES];
    }
    
    if ([title isEqualToString:@"优惠券"]) {
//        [BaseWebVC showWithContro:self withUrlStr:HTML_CouponPage withTitle:@"优惠券" isPresent:NO];
        CouponVC *couponVC = [[CouponVC alloc] init];
        couponVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:couponVC animated:YES];
    }
    
    if ([title isEqualToString:@"地址管理"]) {
//        [BaseWebVC showWithContro:self withUrlStr:HTML_AddressPage withTitle:@"地址管理" isPresent:NO];
        AddressVC *addressVC = [[AddressVC alloc] init];
        addressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    
    if ([title isEqualToString:@"修改密码"]) {
        RegisterForgetPswVC *changePswVC = [[RegisterForgetPswVC alloc] init];
        changePswVC.state = StateChangePsw;
        changePswVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changePswVC animated:YES];
    }
    
    if ([title isEqualToString:@"在线客服"]) {
//        ContactUsVC *contactUsVC = [[ContactUsVC alloc] init];
//        contactUsVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:contactUsVC animated:YES];
        
        if ([[EMClient sharedClient] isLoggedIn]) { //环信是否登录
            ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        } else {
            [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
                    chatVC.hidesBottomBarWhenPushed = YES;
                    chatVC.height = 0;
                    [self.navigationController pushViewController:chatVC animated:YES];
                }
            }];
        }
    }
    
    if ([title isEqualToString:@"帮助中心"]) {
//        HelpVC *helpVC = [[HelpVC alloc] init];
//        helpVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:helpVC animated:YES];
        [BaseWebVC showWithContro:self withUrlStr:HTML_HelpCenter withTitle:@"帮助中心" isPresent:NO withShareContent:@""];
    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (contentOffsety<0) {
        CGRect rect = _bgImg.frame;
        rect.size.height = _bgImgHeight-contentOffsety;
        rect.size.width = _bgImgWidth* (_bgImgHeight-contentOffsety)/_bgImgHeight;
        rect.origin.x =  -(rect.size.width-_bgImgWidth)/2;
        rect.origin.y = 0;
        _bgImg.frame = rect;
    }else{
        CGRect rect = _bgImg.frame;
        rect.size.height = _bgImgHeight;
        rect.size.width = _bgImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _bgImg.frame = rect;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate=self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:NO completion:^{}];
        }
            break;
        case 1:
        {
            if ([Utils isCameraPermissionOn]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:imagePickerController animated:NO completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *iconImage = info[UIImagePickerControllerEditedImage];
        
        headImgPath = [AEFilePath filePathWithType:AEFilePathType_IconPath withFileName:nil];
        [UIImageJPEGRepresentation(iconImage, 0.01) writeToFile:headImgPath atomically:YES];
        
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"cover", @"type",
                             [UserInfo share].userID, @"member_id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_UploadImage parameters:dic imagePath:headImgPath completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            if (status == Request_Success) {
                _bgImg.image = iconImage;
                [Utils showToast:@"封面修改成功"];
            }
        }];
    });
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES; //隐藏导航条
    
    if ([Utils isUserLogin]) {
        [self getData]; //获取个人信息
    }
    
    //CGRectMake(0, 0, 1, 1)可以直接返回到UITableView的最顶端
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:HXChatter type:EMConversationTypeChat createIfNotExist:YES];
    int unreadCount = conversation.unreadMessagesCount;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
