//
//  GuideBookVC.m
//  ArtEast
//
//  Created by Jason on 2018/4/10.
//  Copyright © 2018年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GuideBookVC.h"
#import "PageAnimationView.h"

#define BaseTag 10

/**
 动画偏移量 是指rightView相对于leftView的偏移量
 */
#define AnimationOffset 100

@interface GuideBookVC ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *slogonImg;

@end

@implementation GuideBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArr = @[@"Guide01.jpg", @"Guide02.jpg", @"Guide03.jpg", @"Guide04.jpg"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate =self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4 ; i++) {
        PageAnimationView *view = [[PageAnimationView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
        view.tag = BaseTag + i;
        view.imageView.image = [UIImage imageNamed:imageArr[i]];
        [_scrollView addSubview:view];
        
        if (i==3) {
            //进入按钮
            CGFloat btnW = 255*HEIGHT/667;
            CGFloat btnH = 45*HEIGHT/667;
            UIImageView *enterImg = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-btnW)/2, HEIGHT-btnH*4, btnW, btnH)];
            enterImg.userInteractionEnabled = YES;
            enterImg.image = [UIImage imageNamed:@"EnterBtn"];
            [view addSubview:enterImg];
            
            UIView *enterView = [[UIView alloc] initWithFrame:enterImg.frame];
            [view addSubview:enterView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [enterView addGestureRecognizer:tap];
            
            //Slogon
            _slogonImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/4, HEIGHT/2-100, WIDTH/2, 30*(WIDTH/2)/216)];
            _slogonImg.image = [UIImage imageNamed:@"Slogon"];
            _slogonImg.alpha = 0;
            [view addSubview:_slogonImg];
            
            view.imageView.image = [Utils snapshotSingleView:view];
            enterImg.hidden = YES;
        }
    }
}

- (void)tapClick:(UITapGestureRecognizer*)tap {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLG"];
    
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - UIScrollViewDelegate协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat x = fabs(scrollView.contentOffset.x);
    NSInteger leftIndex = x/WIDTH;
    
    //这里的left和right是区分拖动中可见的两个视图
    PageAnimationView * leftView = [scrollView viewWithTag:(leftIndex + BaseTag)];
    PageAnimationView * rightView = [scrollView viewWithTag:(leftIndex + 1 + BaseTag)];
    
    rightView.contentX = -(WIDTH - AnimationOffset) + (x - (leftIndex * WIDTH))/WIDTH * (WIDTH - AnimationOffset);
    leftView.contentX = ((WIDTH- AnimationOffset) + (x - ((leftIndex + 1) * WIDTH))/WIDTH * (WIDTH - AnimationOffset));
    
    if (leftIndex==3) {
        [UIView animateWithDuration:2 animations:^{
            _slogonImg.alpha = 1;
        } completion:^(BOOL finished) {
            PageAnimationView *view = [scrollView viewWithTag:(3 + BaseTag)];
            view.imageView.image = [Utils snapshotSingleView:view];
            _slogonImg.hidden = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
