//
//  PersonalInfoVC.m
//  ArtEast
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "AEUITextField.h"
#import "UIImage+Additions.h"
#import "AEFilePath.h"

@interface PersonalInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_headImgView;
    UIButton *_womanBtn;
    UIButton *_manBtn;
    AEUITextField *_birthTF;
    CGFloat _headHeight;
    UIImagePickerController *_imagePickerC;
    
    UITextField *_nickNameTextField;
    UILabel *_accountLabel;
    
    NSString *headImgPath;
}
@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    _headHeight = 80;
    
    [self getData];
    [self initViews];
}

- (void)getData {
    
}

- (void)initViews{

    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"保存" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = kFont15Size;
    [navRightBtn setTitleColor:kColorFromRGBHex(0x2a2a2a) forState:UIControlStateNormal];
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(SaveMyInfoData) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(WIDTH, _scrollView.height+1);

    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-_headHeight)/2, 80, _headHeight, _headHeight)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"MineHeadIcon"]];
    _headImgView.cornerRadius =_headHeight/2.0;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
  
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _headImgView.maxY+10, WIDTH, 20)];
    label.text = @"点击修改头像";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;

    UIButton *headImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(_headImgView.x, _headImgView.y, _headImgView.width,label.maxY-_headImgView.y)];
    [headImageBtn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, label.maxY+25-64)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView];
    [_scrollView addSubview:_headImgView];
    [_scrollView addSubview:label];
    [_scrollView addSubview:headImageBtn];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, whiteView.maxY+10, WIDTH, 250)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bottomView];

    CGFloat tempHeight = 50;

    //用户ID
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, tempHeight)];
    label1.text = @"用户ID";
    label1.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label1];

    UILabel *userIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.maxX+10, 0, WIDTH-(label1.maxX+10)-15, tempHeight)];
    userIDLabel.font = [UIFont systemFontOfSize:15];
    userIDLabel.text = [UserInfo share].userID;
    userIDLabel.textColor = [UIColor colorWithRed:0.2281 green:0.2281 blue:0.2281 alpha:1.0];
    [bottomView addSubview:userIDLabel];

    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, label1.maxY-0.5, WIDTH-30, .5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView1];

    //昵称
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, label1.maxY, 80, tempHeight)];
    label2.text = @"昵称";
    label2.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label2];

    _nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(label1.maxX+10, label1.maxY, WIDTH-(label1.maxX+10)-15, tempHeight)];
    _nickNameTextField.delegate = self;
    _nickNameTextField.font = [UIFont systemFontOfSize:15];
    _nickNameTextField.text = [UserInfo share].nick;
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.textColor = [UIColor colorWithRed:0.2281 green:0.2281 blue:0.2281 alpha:1.0];
    [bottomView addSubview:_nickNameTextField];

    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(15, label2.maxY-0.5, WIDTH-30, .5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView2];

    //账号
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, label2.maxY, 80, 50)];
    label3.text = @"账号";
    label3.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label3];

    _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.maxX+10, label2.maxY, WIDTH-(label1.maxX+10)-15, 50)];
    _accountLabel.font = [UIFont systemFontOfSize:15];
    _accountLabel.text = [self handleDataForSecurity:[UserInfo share].account];
    _accountLabel.textColor = [UIColor colorWithRed:0.2281 green:0.2281 blue:0.2281 alpha:1.0];
    [bottomView addSubview:_accountLabel];

    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(15, label3.maxY-0.5, WIDTH-30, .5)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView3];

    //用户ID
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(15, label3.maxY, 80, 50)];
    label4.text = @"性别";
    label4.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label4];

    _manBtn = [[UIButton alloc]initWithFrame:CGRectMake(label1.maxX+10, label3.maxY, (WIDTH-(label1.maxX+10)-15)/2.0, 50)];
    _manBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_manBtn setTitle:@"男" forState:UIControlStateNormal];
    [_manBtn setTitleColor:[UIColor colorWithRed:0.2281 green:0.2281 blue:0.2281 alpha:1.0] forState:UIControlStateNormal];
    _manBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_manBtn setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    _manBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
     [_manBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_manBtn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_manBtn];

    _womanBtn = [[UIButton alloc]initWithFrame:CGRectMake(_manBtn.maxX, label3.maxY, _manBtn.width, 50)];
    _womanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
     [_womanBtn setTitleColor:[UIColor colorWithRed:0.2281 green:0.2281 blue:0.2281 alpha:1.0] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    _womanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     _womanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
     [_womanBtn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_womanBtn];
    
    if ([UserInfo share].sex==0) {
        _womanBtn.selected = YES;
    } else {
        _manBtn.selected = YES;
    }

    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(15, label4.maxY-0.5, WIDTH-30, .5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView4];

    //用户ID
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(15, label4.maxY, 80, 50)];
    label5.text = @"出生日期";
    label5.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:label5];
    
    _birthTF = [[AEUITextField alloc] initDatePickerWithframe:CGRectMake(label1.maxX+10, label4.maxY, WIDTH-(label1.maxX+10)-15, 50) haveLimit:0];
    _birthTF.font = [UIFont systemFontOfSize:15];
    //最小只能选择距现在100年前
    _birthTF.inputDatePickerView.minimumDate = [self earilstDateWithYear:-100];
    _birthTF.inputDatePickerView.maximumDate = [NSDate date];
    _birthTF.inputDatePickerView.backgroundColor = [UIColor whiteColor];
    _birthTF.placeholder = @"请选择您的出生日期";
    if (![[UserInfo share].birthday isEqualToString:@"--"] && ![[UserInfo share].birthday isEqualToString:@"0-0-0"]) {
        _birthTF.text = [UserInfo share].birthday;
    }
    _birthTF.delegate = self;
    _birthTF.textColor = [UIColor blackColor];
    _birthTF.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:_birthTF];

    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(15, label5.maxY-0.5, WIDTH-30, .5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.8424 green:0.8424 blue:0.8424 alpha:1.0];
    [bottomView addSubview:lineView5];
}

-(NSDate *)earilstDateWithYear:(int)year{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    NSDate *earliestDay = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    return earliestDay;
}

#pragma mark - 保存修改的信息
- (void)SaveMyInfoData {
    [self.view endEditing:YES];
    
    NSString *birthStr = _birthTF.text;
    NSArray *birthArr = [birthStr componentsSeparatedByString:@"-"];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSString *avatarStr = userDic[@"avatar"];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    if ([Utils isBlankString:headImgPath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _nickNameTextField.text, @"name",
                             _accountLabel.text, @"login_account",
                             avatarStr, @"avatar",
                             _manBtn.selected == YES?@"1":@"0", @"sex",
                             [UserInfo share].phone, @"mobile",
                             _birthTF.text.length>0?birthArr[0]:@"", @"b_year",
                             _birthTF.text.length>0?birthArr[1]:@"", @"b_month",
                             _birthTF.text.length>0?birthArr[2]:@"", @"b_day",
                             [UserInfo share].userID, @"member_id",
                             nil];
        
        [[NetworkManager sharedManager] postJSON:URL_EditPersonalInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"更新个人资料成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"avatar", @"type",
                             [UserInfo share].userID, @"member_id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_UploadImage parameters:dic imagePath:headImgPath completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _nickNameTextField.text, @"name",
                                     _accountLabel.text, @"login_account",
                                     responseData, @"avatar",
                                     _manBtn.selected == YES?@"1":@"0", @"sex",
                                     [UserInfo share].phone, @"mobile",
                                     _birthTF.text.length>0?birthArr[0]:@"", @"b_year",
                                     _birthTF.text.length>0?birthArr[1]:@"", @"b_month",
                                     _birthTF.text.length>0?birthArr[2]:@"", @"b_day",
                                     [UserInfo share].userID, @"member_id",
                                     nil];
                
                [[NetworkManager sharedManager] postJSON:URL_EditPersonalInfo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                    
                    [JHHJView hideLoading]; //结束加载
                    
                    if (status == Request_Success) {
                        [Utils showToast:@"更新个人资料成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            } else {
                [JHHJView hideLoading]; //结束加载
            }
        }];
    }
}

#pragma mark - 头像点击
- (void)headClick{
    [self.view endEditing:YES]; //隐藏键盘
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
    [sheet showInView:self.view];
}

#pragma mark - 修改性别
- (void)selectSex:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = ! sender.selected;

    if ([sender isEqual:_manBtn]) {
        _womanBtn.selected = !_manBtn.selected;
    }else{
         _manBtn.selected = !_womanBtn.selected;
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
        _headImgView.image = iconImage;
        
        headImgPath = [AEFilePath filePathWithType:AEFilePathType_IconPath withFileName:nil];
        [UIImageJPEGRepresentation(iconImage, 0.01) writeToFile:headImgPath atomically:YES];
    });
}

- (NSString *)handleDataForSecurity:(NSString *)dataStr{
    NSString *foreStr = [[dataStr componentsSeparatedByString:@"@"] firstObject];
    NSString *lastStr = [[dataStr componentsSeparatedByString:@"@"] lastObject];
    if ([dataStr componentsSeparatedByString:@"@"].count==1) {
        return foreStr;
    }

    return [NSString stringWithFormat:@"%@****%@@%@",[foreStr substringToIndex:1],[foreStr substringFromIndex:foreStr.length-1],lastStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
