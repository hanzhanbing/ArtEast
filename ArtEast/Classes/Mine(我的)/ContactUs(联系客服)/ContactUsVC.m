//
//  ContactUsVC.m
//  ArtEast
//
//  Created by yibao on 16/11/9.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ContactUsVC.h"

@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系客服";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, WIDTH/3)];
    imageView.image = [UIImage imageNamed:@"ContactUs"];
    [self.view addSubview:imageView];
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.maxY+10, WIDTH, 100)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBgView];
    
    UILabel *telLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 72, 20)];
    telLab.text = @"客服电话：";
    telLab.font = [UIFont systemFontOfSize:14];
    telLab.textColor = PlaceHolderColor;
    [whiteBgView addSubview:telLab];
    
    UIButton *telBtn = [[UIButton alloc] initWithFrame:CGRectMake(telLab.maxX, 15, WIDTH/2, 20)];
    telBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    telBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [telBtn setTitle:ContactPhone forState:UIControlStateNormal];
    [telBtn setTitleColor:kColorFromRGBHex(0x368beb) forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:telBtn];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-95, 15, 80, 20)];
    timeLab.text = @"9:00-18:00";
    timeLab.hidden = YES;
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = PlaceHolderColor;
    [whiteBgView addSubview:timeLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    line.backgroundColor = LineColor;
    [whiteBgView addSubview:line];
    
    UILabel *emailLab = [[UILabel alloc] initWithFrame:CGRectMake(15, line.maxY+15, 72, 20)];
    emailLab.text = @"公司邮箱：";
    emailLab.font = [UIFont systemFontOfSize:14];
    emailLab.textColor = PlaceHolderColor;
    [whiteBgView addSubview:emailLab];
    
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake(telLab.maxX, line.maxY+15, WIDTH/2, 20)];
    emailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    emailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [emailBtn setTitle:CompanyEmail forState:UIControlStateNormal];
    [emailBtn setTitleColor:kColorFromRGBHex(0x368beb) forState:UIControlStateNormal];
    [emailBtn addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:emailBtn];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 20)];
    tipLab.text = @"COPYRIGHT*2014-2017 北京艺宝网络文化有限公司";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = PlaceHolderColor;
    tipLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipLab];
}

#pragma mark - methods

//打电话
- (void)call {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"010-65663699" message:@"分机号：668" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-65663699"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }])];
    [self presentViewController:alertController animated:true completion:nil];
}

//邮件
- (void)email:(UIButton *)btn {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    [pab setString:btn.titleLabel.text];
    
    if (pab == nil) {
        [Utils showToast:@"复制失败"];
    } else {
        [Utils showToast:@"已复制"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
