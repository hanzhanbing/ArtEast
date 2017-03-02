//
//  RegisterForgetPswVC.m
//  ArtEast
//
//  Created by yibao on 16/10/12.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "RegisterForgetPswVC.h"
#import "BaseWebVC.h"
#import "AESCrypt.h"

#define kCountDownTime 59

@interface RegisterForgetPswVC ()

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

@implementation RegisterForgetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.state == StateRegister) {
        self.title = @"注册";
        _typeList=@[@"请输入手机号",@"请输入验证码",@"请输入密码",@"请确认密码"];
    } else if (self.state == StateForgetPsw){
        self.title = @"找回密码";
        _typeList=@[@"请输入手机号",@"请输入验证码",@"请输入新密码",@"请再次输入新密码"];
    } else if (self.state == StateChangePsw){
        self.title = @"修改密码";
        _typeList=@[@"请输入手机号",@"请输入验证码",@"请输入新密码",@"请再次输入新密码"];
    }
    
    [self initView];
}

#pragma mark - init view

- (void)initView {
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, WIDTH, 200)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.userInteractionEnabled = YES;
    [self.view addSubview:whiteBgView];
    
    for (int i=0; i<_typeList.count; i++) {
        UIView *lineView;
        
        if (i==1) {
            _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _codeBtn.backgroundColor = [UIColor clearColor];
            _codeBtn.frame=CGRectMake(WIDTH-105, 59.5, 86, 32);
            _codeBtn.layer.cornerRadius=5;
            _codeBtn.layer.masksToBounds=YES;
            _codeBtn.layer.borderWidth = 1;
            _codeBtn.layer.borderColor = PlaceHolderColor.CGColor;
            _codeBtn.userInteractionEnabled = YES;
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_codeBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
            _codeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [_codeBtn addTarget:self action:@selector(startCountDown) forControlEvents:UIControlEventTouchUpInside];
            [whiteBgView addSubview:_codeBtn];
        }
        
        if (i!=_typeList.count-1) {
            lineView=[[UIView alloc] initWithFrame:CGRectMake(15, 50*(i+1), WIDTH-8, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:0.9412 green:0.9412 blue:0.9412 alpha:1.0];
            [whiteBgView addSubview:lineView];
        }
    }
    
    _phoneTF=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, WIDTH-120, 50)];
    _phoneTF.font = [UIFont systemFontOfSize:14];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.placeholder=_typeList[0];
    [_phoneTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTF.delegate=self;
    [whiteBgView addSubview:_phoneTF];
    
    _codeTF=[[UITextField alloc] initWithFrame:CGRectMake(15, 50, WIDTH-120, 50)];
    _codeTF.font = [UIFont systemFontOfSize:14];
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.placeholder=_typeList[1];
    [_codeTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _codeTF.delegate=self;
    [whiteBgView addSubview:_codeTF];
    
    _pwdTF=[[UITextField alloc] initWithFrame:CGRectMake(15, 100, WIDTH-120, 50)];
    _pwdTF.font = [UIFont systemFontOfSize:14];
    _pwdTF.placeholder=_typeList[2];
    [_pwdTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _pwdTF.delegate=self;
    _pwdTF.secureTextEntry=YES;
    [whiteBgView addSubview:_pwdTF];
    
    _enterTF=[[UITextField alloc] initWithFrame:CGRectMake(15, 150, WIDTH-120, 50)];
    _enterTF.font = [UIFont systemFontOfSize:14];
    _enterTF.placeholder=_typeList[3];
    [_enterTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _enterTF.delegate=self;
    _enterTF.secureTextEntry=YES;
    [whiteBgView addSubview:_enterTF];
    
    if (self.state == StateRegister) {
        _chickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _chickBtn.frame=CGRectMake(15, CGRectGetMaxY(whiteBgView.frame)+15, 15, 15);
        [_chickBtn setBackgroundImage:[UIImage imageNamed:@"Protocol_UnSelected"] forState:UIControlStateNormal];
        [_chickBtn setBackgroundImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateSelected];
        _chickBtn.selected = YES;
        [_chickBtn addTarget:self action:@selector(chickService:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_chickBtn];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_chickBtn.frame)+5, CGRectGetMaxY(whiteBgView.frame)+15, 72, 16)];
        lab.text=@"阅读并同意";
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=PlaceHolderColor;
        [self.view addSubview:lab];
        
        _userServiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _userServiceBtn.frame=CGRectMake(CGRectGetMaxX(lab.frame)+2, CGRectGetMaxY(whiteBgView.frame)+14, 100, 16);
        [_userServiceBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [_userServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _userServiceBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _userServiceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _userServiceBtn.userInteractionEnabled = YES;
        [_userServiceBtn addTarget:self action:@selector(userService) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_userServiceBtn];
        
        CGSize lineSize = [@"服务协议" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame)+2, _userServiceBtn.maxY+1, lineSize.width, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:lineView];
    }
    
    _submitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    if (self.state == StateRegister) {
        _submitBtn.frame=CGRectMake(20, CGRectGetMaxY(whiteBgView.frame)+80, WIDTH-40, 45);
    } else {
        _submitBtn.frame=CGRectMake(20, CGRectGetMaxY(whiteBgView.frame)+50, WIDTH-40, 45);
    }
    _submitBtn.backgroundColor=LightYellowColor;
    if (self.state == StateRegister) {
        [_submitBtn setTitle:@"注册" forState:UIControlStateNormal];
    } else if (self.state == StateForgetPsw){
        [_submitBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    } else if (self.state == StateChangePsw){
        [_submitBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }
    [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _submitBtn.layer.cornerRadius=5;
    _submitBtn.layer.masksToBounds=YES;
    [_submitBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
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
        if (self.state == StateRegister) {
            //注册
            [self regiserAction];
        } else if (self.state == StateForgetPsw){
            //忘记密码
            [self forgetPsw];
        } else if (self.state == StateChangePsw){
            //修改密码
            [self forgetPsw];
        }
    }
}

//注册
- (void)regiserAction {
    
    if (_chickBtn.selected == NO) {
        [Utils showToast:@"请勾选服务协议"];
    } else {
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phoneTF.text, @"uname",
                             [AESCrypt encrypt:_pwdTF.text password:AESSecret], @"password",
                             _codeTF.text, @"vcode",
                             nil];
        
        [[NetworkManager sharedManager] postJSON:URL_Register parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"注册成功"];
                
                [[EMClient sharedClient] registerWithUsername:responseData[@"member_id"] password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",responseData[@"member_id"]]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        NSLog(@"注册成功");
                    }
                }];
                [self.navigationController popViewControllerAnimated:YES]; //关闭页面
            }
        }];
    }
}

//忘记密码
- (void)forgetPsw {
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _phoneTF.text, @"username",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_CheckUserName parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"mobile", @"send_type",
                                 _phoneTF.text, @"username",
                                 _codeTF.text, @"vcode",
                                 nil];
            [[NetworkManager sharedManager] postJSON:URL_FindPswCheckCode parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _phoneTF.text, @"account",
                                         @"", @"key",
                                         [AESCrypt encrypt:_pwdTF.text password:AESSecret], @"login_password",
                                         [AESCrypt encrypt:_enterTF.text password:AESSecret], @"psw_confirm",
                                         [UserInfo share].userID, @"member_id",
                                         nil];
                    [[NetworkManager sharedManager] postJSON:URL_FindPswSetPsw parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                        
                        [JHHJView hideLoading]; //结束加载
                        if (status == Request_Success) {
                            [Utils showToast:@"密码找回成功，请重新登录"];
                            [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                        }
                    }];
                } else {
                    [JHHJView hideLoading]; //结束加载
                }
            }];
        } else {
            [JHHJView hideLoading]; //结束加载
        }
    }];
}

-(void)chickService:(UIButton *)chink
{
    if (_chickBtn.selected==YES) {
        _chickBtn.selected=NO;
    } else {
        _chickBtn.selected=YES;
    }
}

-(void)userService
{
    //[BaseWebVC showWithContro:self withUrlStr:@"" withTitle:@"用户使用协议"];
}

#pragma mark - 获取验证码

- (void)startCountDown
{
    [self.view endEditing:YES];
    
    if (_phoneTF.text.length==11) {
        _countDownTime = kCountDownTime;
        _codeBtn.layer.cornerRadius=5;
        _codeBtn.layer.masksToBounds=YES;
        [_codeBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
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
    [_codeBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    _codeBtn.userInteractionEnabled = YES;
    [_timer invalidate];
    
    //防止_timer被释放掉后还继续访问
    _timer = nil;
}

//获取验证码
- (void)getSmsCode
{
    NSDictionary *dic = nil;
    
    if (self.state == StateRegister) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phoneTF.text, @"uname",
                             @"signup", @"type",
                             nil];
    } else if (self.state == StateForgetPsw){
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phoneTF.text, @"uname",
                             @"forgot", @"type",
                             nil];
    } else if (self.state == StateChangePsw){
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _phoneTF.text, @"uname",
                             @"forgot", @"type",
                             nil];
    }
    
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
