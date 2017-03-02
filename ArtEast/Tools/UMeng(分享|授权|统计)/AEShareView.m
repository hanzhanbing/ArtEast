//
//  AEShareView.m
//  ArtEast
//
//  Created by yibao on 16/9/23.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEShareView.h"

#define UMSBUNDLE_NAME @"UMSocialSDKResourcesNew.bundle"

@interface AEShareView ()
{
    //分享view
    UIView *shareView;
    //取消view
    UIView *cancelView;
}
@end

@implementation AEShareView

- (id)initWithBaseController:(UIViewController *)bController andBaseView:(UIView *)bView andData:(NSMutableDictionary *)dic andType:(ShareType)type {
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        self.baseController = bController;
        self.baseView = bView;
        self.paramDic = dic;
        self.shareType = type;
        
        [self.baseView addSubview:self];
        
        [self initView]; //初始化视图
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    //分享View
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 255)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:shareView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, WIDTH, 5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:lineView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, WIDTH-12, 5)];
    grayView.cornerRadius = 1;
    grayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [lineView addSubview:grayView];
    
    //取消View
    cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame), WIDTH, 45)];
    cancelView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:cancelView];
    
    //分享标题
    UILabel *shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    shareTitle.text = @"分享";
    shareTitle.font = kFont18Size;
    shareTitle.textAlignment = NSTextAlignmentCenter;
    shareTitle.textColor = [UIColor blackColor];
    [shareView addSubview:shareTitle];
    
    
    NSArray *shareImageArr =[NSArray arrayWithObjects:@"Wechat",@"Wechat_Timeline",@"QQ",@"QZone",@"Sina", nil];
    NSArray *shareNameArr = [NSArray arrayWithObjects:@"微信",@"朋友圈",@"QQ",@"QQ空间",@"新浪微博", nil];
    
    /*
     创建分享按钮
     **/
    int col = 4;
    int j = 0;
    for (int i = 0; i<shareImageArr.count; i++) {
        if (i%col==0&&i!=0) {
            j++;
        }
        
        //背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/col*(i%col), 40+100*j, WIDTH/col, 100)];
        [shareView addSubview:bgView];
        
        //图标
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/col/2-27.5, 10, 55, 55)];
        shareBtn.tag = i+1;
        [shareBtn setBackgroundImage:[UIImage imageNamed:shareImageArr[i]] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:shareBtn];
        
        //文字
        UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareBtn.frame)+8, WIDTH/col, 20)];
        shareLab.font = kFont15Size;
        shareLab.textAlignment = NSTextAlignmentCenter;
        shareLab.text = shareNameArr[i];
        [bgView addSubview:shareLab];
    }
    
    UIButton *quxiaoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    quxiaoBtn.frame = CGRectMake(0, 0, WIDTH, 45);
    quxiaoBtn.backgroundColor = [UIColor clearColor];
    [quxiaoBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    quxiaoBtn.titleLabel.font = kFont18Size;
    [quxiaoBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [quxiaoBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelView addSubview:quxiaoBtn];
}

#pragma mark - 弹出分享
-(void)show {
    shareView.alpha = 0.5;
    cancelView.alpha = 0.5;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect shareFrame = shareView.frame;
        shareFrame.origin.y = HEIGHT-300;
        shareView.frame = shareFrame;
        cancelView.frame = CGRectMake(0, CGRectGetMaxY(shareView.frame), WIDTH, 45);
        
        shareView.alpha = 1;
        cancelView.alpha = 1;
    }];
}

#pragma mark - 取消分享
-(void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect shareFrame = shareView.frame;
        shareFrame.origin.y = HEIGHT;
        shareView.frame = shareFrame;
        cancelView.frame = CGRectMake(0, CGRectGetMaxY(shareView.frame), WIDTH, 45);
        
        shareView.alpha = 0.5;
        cancelView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self dismissAlert];
    }];
}

#pragma mark - 页面消失
- (void)dismissAlert {
    [self removeFromSuperview];
    shareView.hidden = YES;
    cancelView.hidden = YES;
}

#pragma mark - 分享点击事件
-(void)shareClick:(UIButton *)sender {
    UIButton *Btn = (UIButton *)sender;
    NSInteger index = Btn.tag-1;
    switch (index) {
        case 0:
            [AEUMengCenter shareWithData:self.paramDic andType:self.shareType toPlatform:UMSocialPlatformType_WechatSession withBaseController:self.baseController]; //分享微信好友
            
            break;
        case 1:
            [AEUMengCenter shareWithData:self.paramDic andType:self.shareType toPlatform:UMSocialPlatformType_WechatTimeLine withBaseController:self.baseController];; //分享微信朋友圈
            
            break;
        case 2:
            [AEUMengCenter shareWithData:self.paramDic andType:self.shareType toPlatform:UMSocialPlatformType_QQ withBaseController:self.baseController];; //分享QQ
            
            break;
        case 3:
            [AEUMengCenter shareWithData:self.paramDic andType:self.shareType toPlatform:UMSocialPlatformType_Qzone withBaseController:self.baseController];; //分享QQ空间
            
            break;
        case 4:
            [AEUMengCenter shareWithData:self.paramDic andType:ShareText toPlatform:UMSocialPlatformType_Sina withBaseController:self.baseController];; //分享新浪微博
            
            break;
            
        default:
            break;
    }
    [self dismiss];
}

@end
