//
//  AEMoreView.m
//  ArtEast
//
//  Created by yibao on 16/11/2.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEMoreView.h"

@interface AEMoreView ()
{
    //更多view
    UIView *moreView;
    //取消按钮
    UIButton *cancelBtn;
}
@end

@implementation AEMoreView

- (id)initWithBaseController:(UIViewController *)bController andBaseView:(UIView *)bView {
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        self.baseController = bController;
        self.baseView = bView;
        
        [self.baseView addSubview:self];
        
        [self initView]; //初始化视图
        
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    //更多View
    moreView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 95)];
    moreView.backgroundColor = kColorFromRGBHex(0xEEEEEE);
    [self.baseView addSubview:moreView];
    
    //背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH*3/8, 0, WIDTH/4, 90)];
    [moreView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelCollect)];
    [bgView addGestureRecognizer:tap];
    
    //图标
    UIButton *cancelCollectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/8-22.5, 15, 45, 45)];
    cancelCollectBtn.userInteractionEnabled = NO;
    [cancelCollectBtn setBackgroundImage:[UIImage imageNamed:@"MoreCollect"] forState:UIControlStateNormal];
    [bgView addSubview:cancelCollectBtn];
    
    //文字
    UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cancelCollectBtn.frame)+5, WIDTH/4, 20)];
    shareLab.font = [UIFont systemFontOfSize:12];
    shareLab.textAlignment = NSTextAlignmentCenter;
    shareLab.text = @"取消关注";
    [bgView addSubview:shareLab];
    
    //取消按钮
    cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(moreView.frame), WIDTH, 45);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:cancelBtn];
}

#pragma mark - 弹出分享
-(void)show {
    moreView.alpha = 0.5;
    cancelBtn.alpha = 0.5;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect moreFrame = moreView.frame;
        moreFrame.origin.y = HEIGHT-140;
        moreView.frame = moreFrame;
        cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(moreView.frame), WIDTH, 45);
        
        moreView.alpha = 1;
        cancelBtn.alpha = 1;
    }];
}

#pragma mark - 取消分享
-(void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect moreFrame = moreView.frame;
        moreFrame.origin.y = HEIGHT;
        moreView.frame = moreFrame;
        cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(moreView.frame), WIDTH, 45);
        
        moreView.alpha = 0.5;
        cancelBtn.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self dismissAlert];
    }];
}

#pragma mark - 页面消失
- (void)dismissAlert {
    [self removeFromSuperview];
    moreView.hidden = YES;
    cancelBtn.hidden = YES;
}

#pragma mark - 取消关注事件
-(void)cancelCollect {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
    [self dismiss];
}

@end
