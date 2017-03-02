//
//  BindingMobileVC.m
//  ArtEast
//
//  Created by mac on 2030/10/31.
//  Copyright © 2030年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BindingMobileVC.h"
#import "BaseWebVC.h"
#import "AESCrypt.h"
#import "JPUSHService.h"

#define kCountDownTime 59

@interface BindingMobileVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) UITextField *pwdTF;
@property (nonatomic,strong) UITextField *enterTF;
@property (nonatomic,strong) UIButton *codeBtn;
@property (nonatomic,strong) UIButton *chickBtn;
@property (nonatomic,strong) UIButton *userServiceBtn;
@property (nonatomic,strong) UIButton *submitBtn;

@property (nonatomic,strong) NSArray *typeList;

//短信验证码相关
@property (nonatomic,assign) NSUInteger countDownTime;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation BindingMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"绑定手机";
    _typeList=@[@"请输入手机号码",@"验证码",@"密码",@"确认密码"];
    
    [self initView];
}

#pragma mark - init view 

- (void)initView {

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(WIDTH, _scrollView.height+1);

    UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-80)/2.0, 64+20, 80, 80)];
    logoImg.image = [UIImage imageNamed:@"BindPhone"];
    [_scrollView addSubview:logoImg];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, logoImg.maxY+15, WIDTH-20, 40)];
    label.text = @"为了保护您的财产安全\n请及时绑定手机号";
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [_scrollView addSubview:label];

    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, label.maxY+15, WIDTH, 200)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.userInteractionEnabled = YES;
    [_scrollView addSubview:whiteBgView];
    
    for (int i=0; i<_typeList.count; i++) {
        UIView *lineView;
        
        if (i==1) {
            _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _codeBtn.backgroundColor = ButtonBgColor;
            _codeBtn.frame=CGRectMake(WIDTH-105, 57.5, 90, 35);
            _codeBtn.layer.cornerRadius=5;
            _codeBtn.layer.masksToBounds=YES;
            _codeBtn.userInteractionEnabled = YES;
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_codeBtn setTitleColor:ButtonFontColor forState:UIControlStateNormal];
            _codeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [_codeBtn addTarget:self action:@selector(startCountDown) forControlEvents:UIControlEventTouchUpInside];
            [whiteBgView addSubview:_codeBtn];
        }
        
//        if (i!=_typeList.count-1) {
            lineView=[[UIView alloc] initWithFrame:CGRectMake(15, 50*(i+1), WIDTH-8, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:0.9412 green:0.9412 blue:0.9412 alpha:1.0];
            [whiteBgView addSubview:lineView];
//        }
    }
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, -0.5, 40, 50)];
    leftLabel.text = @"+86";
    leftLabel.textColor = kColorFromRGBHex(0x868686);
    leftLabel.font = [UIFont systemFontOfSize:15];
    [whiteBgView addSubview:leftLabel];
    
    _phoneTF=[[UITextField alloc] initWithFrame:CGRectMake(leftLabel.maxX, 0, WIDTH-120, 50)];
    _phoneTF.font = [UIFont systemFontOfSize:14];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.placeholder=_typeList[0];
    [_phoneTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTF.delegate=self;
    [whiteBgView addSubview:_phoneTF];
    
    _codeTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 50, WIDTH-120, 50)];
    _codeTF.font = [UIFont systemFontOfSize:14];
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.placeholder=_typeList[1];
    [_codeTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _codeTF.delegate=self;
    [whiteBgView addSubview:_codeTF];
    
    _pwdTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 100, WIDTH-120, 50)];
    _pwdTF.font = [UIFont systemFontOfSize:14];
    _pwdTF.placeholder=_typeList[2];
    [_pwdTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _pwdTF.delegate=self;
    _pwdTF.secureTextEntry=YES;
    [whiteBgView addSubview:_pwdTF];
    
    _enterTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 150, WIDTH-120, 50)];
    _enterTF.font = [UIFont systemFontOfSize:14];
    _enterTF.placeholder=_typeList[3];
    [_enterTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _enterTF.delegate=self;
    _enterTF.secureTextEntry=YES;
    [whiteBgView addSubview:_enterTF];
    
    _chickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _chickBtn.frame=CGRectMake(20, CGRectGetMaxY(whiteBgView.frame)+15, 15, 15);
    [_chickBtn setBackgroundImage:[UIImage imageNamed:@"Protocol_UnSelected"] forState:UIControlStateNormal];
    [_chickBtn setBackgroundImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateSelected];
    _chickBtn.selected = YES;
    _chickBtn.userInteractionEnabled = YES;
    [_chickBtn addTarget:self action:@selector(chickService:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_chickBtn];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_chickBtn.frame)+5, CGRectGetMaxY(whiteBgView.frame)+15, 72, 16)];
    lab.text=@"阅读并同意";
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=PlaceHolderColor;
    [_scrollView addSubview:lab];
    
    _userServiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _userServiceBtn.frame=CGRectMake(CGRectGetMaxX(lab.frame), CGRectGetMaxY(whiteBgView.frame)+15, 100, 16);
    [_userServiceBtn setTitle:@"服务协议" forState:UIControlStateNormal];
    [_userServiceBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _userServiceBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _userServiceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _userServiceBtn.userInteractionEnabled = YES;
    [_userServiceBtn addTarget:self action:@selector(userService) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_userServiceBtn];
    
    _submitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame=CGRectMake(20, CGRectGetMaxY(whiteBgView.frame)+80, WIDTH-40, 45);
    _submitBtn.backgroundColor=ButtonBgColor;
    [_submitBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:ButtonFontColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _submitBtn.layer.cornerRadius=5;
    _submitBtn.layer.masksToBounds=YES;
    [_submitBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitBtn];
    
}

#pragma mark - 注册、找回密码、修改密码

-(void)clickAction
{
    [self.view endEditing:YES];
    
    if (_phoneTF.text.length!=11) {
        [Utils showToast:@"请输入正确的手机号"];
    } else if (_codeTF.text.length<1) {
        [Utils showToast:@"请输入验证码"];
    } else if (_pwdTF.text.length<1) {
        [Utils showToast:@"请输入密码"];
    } else if (_pwdTF.text.length<6) {
        [Utils showToast:@"密码长度至少6位"];
    } else if (_enterTF.text.length<1) {
        [Utils showToast:@"请再次确认密码"];
    } else if (![_pwdTF.text isEqualToString:_enterTF.text]) {
        [Utils showToast:@"密码不一致，请重新输入"];
    } else {
        [self regiserAction];
    }
}

//注册
- (void)regiserAction {
    
    if (_chickBtn.selected == NO) {
        [Utils showToast:@"请勾选服务协议"];
    } else {
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phoneTF.text, @"login_account",
                             [AESCrypt encrypt:_pwdTF.text password:AESSecret], @"password",
                             _codeTF.text, @"vcode",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdLoginType"], @"provider_code",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"Avatar"], @"avatar",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenId"], @"openid",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"], @"nickname",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"], @"realname",
                             nil];
        
        [[NetworkManager sharedManager] postJSON:URL_BindPhone parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"绑定成功"];
                
                [[EMClient sharedClient] registerWithUsername:responseData password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",responseData]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        NSLog(@"注册成功");
                    }
                }];
                
                if ([responseData isKindOfClass:[NSString class]]&&![Utils isBlankString:responseData]) {
                    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
                    [userDic setValue:responseData forKey:@"member_id"];
                    [[UserInfo share] setUserInfo:userDic];
                }
                
                [JPUSHService setTags:[NSSet set] alias:[UserInfo share].userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    
                }]; //绑定别名
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                
                if (self.navigationController.viewControllers.count>2) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
                } else {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];
                }
            }
        }];
    }
}

//返回
- (void)backAction {
    _countDownTime = -1;
    [[UserInfo share] setUserInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Avatar"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"OpenId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"RealName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"NickName"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)chickService:(UIButton *)chink
{
    if (chink.selected==YES) {
        _chickBtn.selected=NO;
    } else {
        _chickBtn.selected=YES;
    }
}

-(void)userService
{
    //[BaseWebVC showWithContro:self withUrlStr:@"http://www.baidu.com" withTitle:@"用户使用协议"];
}

#pragma mark - 获取验证码

- (void)startCountDown
{
    [self.view endEditing:YES];
    
    if (_phoneTF.text.length==11) {
        _countDownTime = kCountDownTime;
        _codeBtn.layer.cornerRadius=5;
        _codeBtn.layer.masksToBounds=YES;
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lu秒",(unsigned long)_countDownTime] forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        [self getSmsCode];
    } else {
        [Utils showToast:@"请输入正确的手机号"];
    }
}

- (void)changeTime
{
    _countDownTime--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu秒",(unsigned long)_countDownTime] forState:UIControlStateNormal];
    if (_countDownTime <= 0)
    {
        [self timerOver];
    }
}

//定时器结束
- (void)timerOver
{
    _codeBtn.layer.cornerRadius=5;
    _codeBtn.layer.masksToBounds=YES;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    _codeBtn.userInteractionEnabled = YES;
    [_timer invalidate];
    
    //防止_timer被释放掉后还继续访问
    _timer = nil;
}

//获取验证码
- (void)getSmsCode
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
               _phoneTF.text, @"uname",
               @"activation", @"type",
               nil];
    
    [[NetworkManager sharedManager] postJSON:URL_SmsCode parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
        } else {
            [self timerOver];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
