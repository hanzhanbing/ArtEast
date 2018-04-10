//
//  LoginVC.m
//  ArtEast
//
//  Created by yibao on 16/10/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterForgetPswVC.h"
#import "AEUMengCenter.h"
#import "UserInfo.h"
#import "JPUSHService.h"
#import "AESCrypt.h"
#import "BindingMobileVC.h"
#import "WXApi.h"

@interface LoginVC ()
{
    UITextField *accountTF;
    UITextField *pswTF;
    NSMutableArray *thirdLoginArr;
    
    UIView *_thirdView;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    
    [self initView];
    
    //[self showThirdView];
}

- (void)showThirdView {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_JudgeShowThirdLogin parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            NSString *result = [NSString stringWithFormat:@"%@",responseData];
            if (![result isEqualToString:@"1"]) {
                _thirdView.hidden = NO;
            }
        }
    }];
}

#pragma mark - init view

- (void)initView {
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-36, 35, 16, 16)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    UIButton *clickCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, 25, 40, 40)];
    [clickCloseBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickCloseBtn];
    
    //Logo
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-40, 80, 80, 80)];
    [logoImgView setImage:[UIImage imageNamed:@"LoginLogo"]];
    [self.scrollView addSubview:logoImgView];
    
    //账号
    accountTF = [[UITextField alloc] initWithFrame:CGRectMake(15, logoImgView.maxY+40, WIDTH-30, 20)];
    accountTF.delegate = self;
    accountTF.font = kFont14Size;
    accountTF.placeholder = @"邮箱账号/手机号";
    [accountTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    accountTF.text = @"";
    accountTF.keyboardType = UIKeyboardTypePhonePad;
    [self.scrollView addSubview:accountTF];
    
    //分割线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, accountTF.maxY+15, WIDTH-30, 0.5)];
    line1.backgroundColor = LineColor;
    [self.scrollView addSubview:line1];
    
    pswTF = [[UITextField alloc] initWithFrame:CGRectMake(15, line1.maxY+15, WIDTH-80, 20)];
    pswTF.delegate = self;
    pswTF.font = kFont14Size;
    pswTF.placeholder = @"密码";
    [pswTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    pswTF.text = @"";
    pswTF.secureTextEntry = YES;
    [self.scrollView addSubview:pswTF];
    
    //分割线2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, pswTF.maxY+15, WIDTH-30, 0.5)];
    line2.backgroundColor = LineColor;
    [self.scrollView addSubview:line2];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, line2.maxY+40, WIDTH-30, 45)];
    loginBtn.backgroundColor = LightYellowColor;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn.layer setMasksToBounds:YES];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:loginBtn];
    
    //快速注册
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, loginBtn.maxY+20, 100, 20)];
    registerBtn.backgroundColor = [UIColor clearColor];
    registerBtn.titleLabel.font = kFont14Size;
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; //左对齐
    [registerBtn setTitle:@"注册用户" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:registerBtn];
    
    //找回密码
    UIButton *findPswBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-120, loginBtn.maxY+20, 100, 20)];
    findPswBtn.backgroundColor = [UIColor clearColor];
    findPswBtn.titleLabel.font = kFont14Size;
    findPswBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight; //左对齐
    [findPswBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [findPswBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6] forState:UIControlStateNormal];
    [findPswBtn addTarget:self action:@selector(findPswAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:findPswBtn];
    
    
    _thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, findPswBtn.maxY, WIDTH, 115)];
    [self.scrollView addSubview:_thirdView];
    
    //第三方登录
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-85, 55, 20, 0.5)];
    leftLine.backgroundColor = [UIColor grayColor];
    [_thirdView addSubview:leftLine];
    
    UILabel *thirdLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-50, 45, 100, 20)];
    thirdLab.text = @"第三方软件登录";
    thirdLab.textAlignment = NSTextAlignmentCenter;
    thirdLab.font = kFont14Size;
    thirdLab.textColor = [UIColor grayColor];
    [_thirdView addSubview:thirdLab];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2+65, 55, 20, 0.5)];
    rightLine.backgroundColor = [UIColor grayColor];
    [_thirdView addSubview:rightLine];
    
    int count = (int)thirdLoginArr.count;
    
    for (int i = 0; i<count; i++) {
        
        NSDictionary *dict = thirdLoginArr[i];
        
        //背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/5+WIDTH/5*i, thirdLab.maxY+5, WIDTH/5, 50)];
        bgView.tag = 1000+i;
        [_thirdView addSubview:bgView];
        
        //第三方登录点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdLoginTap:)];
        [bgView addGestureRecognizer:tap];
        
        //图标
        UIButton *icon = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/5/2-12.5, 12, 25, 25)];
        icon.layer.cornerRadius = icon.frame.size.width/2;
        [icon.layer setMasksToBounds:YES];
        [icon setBackgroundImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
        icon.userInteractionEnabled = NO;
        [bgView addSubview:icon];
        
        if (i==1) { //微信登录
            if (![WXApi isWXAppInstalled])
            {
                bgView.hidden = YES;
            }
        }
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH, MAX(self.scrollView.height+1, _thirdView.maxY));
}

#pragma mark - init data

- (void)getData {
    NSMutableDictionary *qq = [NSMutableDictionary dictionary];
    qq[@"title"] = @"QQ";
    qq[@"icon"] = @"QQIcon";
    
    NSMutableDictionary *wechat = [NSMutableDictionary dictionary];
    wechat[@"title"] = @"微信";
    wechat[@"icon"] = @"WechatIcon";
    
    NSMutableDictionary *sina = [NSMutableDictionary dictionary];
    sina[@"title"] = @"新浪微博";
    sina[@"icon"] = @"SinaIcon";
    
    thirdLoginArr = [NSMutableArray arrayWithObjects:qq,wechat,sina, nil];
}

#pragma mark - methods

//微信、QQ、新浪微博第三方登录【授权信息返回待完善】
- (void)thirdLoginTap:(UITapGestureRecognizer *)gesture{
    UIView *clickView = gesture.view;
    int index = (int)clickView.tag-1000;
    switch (index) {
        case 0:
        {
            NSLog(@"QQ登录");
            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_QQ withBaseController:self result:^(LoginResult result, NSString *errorString) {
                [[NSUserDefaults standardUserDefaults] setObject:@"QQ" forKey:@"ThirdLoginType"];
                if (result == ResultLogin) {
                    [Utils showToast:@"登录成功"];
                    [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        
                    }]; //绑定别名
                    //环信注册
                    [[EMClient sharedClient] registerWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        NSLog(@"%d%@",aError.code,aError.errorDescription);
                        if (!aError) {
                            NSLog(@"注册成功");
                        }
                    }];
                    //环信登录
                    [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        if (!aError) {
                            NSLog(@"环信登录成功");
                        }
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                } else if (result == ResultBinding) {
                    BindingMobileVC *bindingMobileVC = [[BindingMobileVC alloc] init];
                    [self.navigationController pushViewController:bindingMobileVC animated:YES];
                } else if (result == ResultFail) {
                    [Utils showToast:@"登录失败，请重试"];
                }
            }];
        }
            break;
        case 1:
        {
            NSLog(@"微信登录");
            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_WechatSession withBaseController:self result:^(LoginResult result, NSString *errorString) {
                [[NSUserDefaults standardUserDefaults] setObject:@"Wechat" forKey:@"ThirdLoginType"];
                if (result == ResultLogin) {
                    [Utils showToast:@"登录成功"];
                    [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        
                    }]; //绑定别名
                    //环信注册
                    [[EMClient sharedClient] registerWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        NSLog(@"%d%@",aError.code,aError.errorDescription);
                        if (!aError) {
                            NSLog(@"注册成功");
                        }
                    }];
                    //环信登录
                    [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        if (!aError) {
                            NSLog(@"环信登录成功");
                        }
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                } else if (result == ResultBinding) {
                    BindingMobileVC *bindingMobileVC = [[BindingMobileVC alloc] init];
                    [self.navigationController pushViewController:bindingMobileVC animated:YES];
                } else if (result == ResultFail) {
                    [Utils showToast:@"登录失败，请重试"];
                }
            }];
        }
            break;
        case 2:
        {
            NSLog(@"新浪微博登录");
            [AEUMengCenter thirdLoginWithPlatform:UMSocialPlatformType_Sina withBaseController:self result:^(LoginResult result, NSString *errorString) {
                [[NSUserDefaults standardUserDefaults] setObject:@"sina" forKey:@"ThirdLoginType"];
                if (result == ResultLogin) {
                    [Utils showToast:@"登录成功"];
                    [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        
                    }]; //绑定别名
                    //环信注册
                    [[EMClient sharedClient] registerWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        NSLog(@"%d%@",aError.code,aError.errorDescription);
                        if (!aError) {
                            NSLog(@"注册成功");
                        }
                    }];
                    //环信登录
                    [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                        if (!aError) {
                            NSLog(@"环信登录成功");
                        }
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                } else if (result == ResultBinding) {
                    BindingMobileVC *bindingMobileVC = [[BindingMobileVC alloc] init];
                    [self.navigationController pushViewController:bindingMobileVC animated:YES];
                } else if (result == ResultFail) {
                    [Utils showToast:@"登录失败，请重试"];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

//登录
- (void)loginAction {
    
    [self.scrollView endEditing:YES];
    
    if (accountTF.text.length!=11) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if (pswTF.text.length<6) {
        [Utils showToast:@"密码长度至少6位"];
        return;
    }
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         accountTF.text, @"uname",
                         [AESCrypt encrypt:pswTF.text password:AESSecret], @"password",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            [[UserInfo share] setUserInfo:responseData];
            
            [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }]; //绑定别名
            
            //环信注册
            [[EMClient sharedClient] registerWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                NSLog(@"%d%@",aError.code,aError.errorDescription);
                if (!aError) {
                    NSLog(@"注册成功");
                }
            }];

            //环信登录
            [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"环信登录成功");
                }
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES]; //关闭页面
        }
    }];
}

//注册
- (void)registerAction {
    NSLog(@"注册");
    RegisterForgetPswVC *registerVC = [[RegisterForgetPswVC alloc] init];
    registerVC.state = StateRegister;
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码？
- (void)findPswAction {
    NSLog(@"忘记密码？");
    RegisterForgetPswVC *forgetPswVC = [[RegisterForgetPswVC alloc] init];
    forgetPswVC.state = StateForgetPsw;
    [self.navigationController pushViewController:forgetPswVC animated:YES];
}

//关闭页面
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES; //隐藏导航条
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
