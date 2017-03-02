//
//  LauncherVC.m
//  ArtEast
//
//  Created by yibao on 2017/1/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "LauncherVC.h"

@interface LauncherVC ()

@property(nonatomic,strong) UIImageView *slogonImg;

@end

@implementation LauncherVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES; //导航条隐藏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  目的：实现启动页面放大渐隐消失
     */
    UIImageView *launchImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    launchImgView.image = [UIImage imageNamed:@"Guide04"];
    [self.view addSubview:launchImgView];
    
    //Slogon
    _slogonImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/4, HEIGHT/2-100, WIDTH/2, 30*(WIDTH/2)/216)];
    _slogonImg.image = [UIImage imageNamed:@"Slogon"];
    [launchImgView addSubview:_slogonImg];
    
    _slogonImg.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        _slogonImg.alpha = 1;
    } completion:^(BOOL finished) {
        [self doneAction]; //完成事件
    }];
}

#pragma mark - 启动动画完成
- (void)doneAction {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end
