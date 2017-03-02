//
//  AEUpdateView.m
//  ArtEast
//
//  Created by yibao on 16/10/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEUpdateView.h"
#import "UIView+Animation.h"

@interface AEUpdateView ()
{
    UIView *bgView; //模糊弹框背景视图
}
@end

@implementation AEUpdateView

- (id)initWithImage:(UIImage *)image
        versionText:(NSString *)version
        contentText:(NSArray *)textArr
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle {
    
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.image = image;
        self.version = version;
        self.textArr = textArr;
        self.leftTitle = leftTitle;
        self.rigthTitle = rigthTitle;
        
        [self initView]; //初始化视图
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
//    imageView.image = self.image;
//    [bgView addSubview:imageView];
    
    UILabel *versionLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    versionLab.text = [NSString stringWithFormat:@"发现新版本(%@)",self.version];
    versionLab.textColor = [UIColor blackColor];
    versionLab.font = [UIFont systemFontOfSize:15];
    versionLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:versionLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, versionLab.maxY, 210, 0.5)];
    lineView.backgroundColor = LineColor;
    [bgView addSubview:lineView];
    
    CGFloat contentHeight = 15;
    for (int i = 0; i<self.textArr.count; i++) {
        CGFloat height = [Utils getTextHeight:self.textArr[i] font:[UIFont systemFontOfSize:14] forWidth:210];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, versionLab.height+contentHeight, 210, height)];
        lab.numberOfLines = 0;
        lab.text = self.textArr[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = kColorFromRGBHex(0x3a3a3a);
        [bgView addSubview:lab];
        contentHeight += height+5;
        
        if (i == self.textArr.count-1) {
            CGFloat offY = CGRectGetMaxY(lab.frame) + 20;
            
            UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width, 0.5)];
            rowLine.backgroundColor = [UIColor colorWithRed:0.4317 green:0.4462 blue:0.5047 alpha:0.5];
            [bgView addSubview:rowLine];
            
            UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, 0.5, 40)];
            colLine.backgroundColor = [UIColor colorWithRed:0.4317 green:0.4462 blue:0.5047 alpha:0.5];
            [bgView addSubview:colLine];
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width/2, 40)];
            cancelBtn.userInteractionEnabled = YES;
            [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:cancelBtn];
            
            UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, bgView.frame.size.width/2, 40)];
            [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
            doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [doneBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
            doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:doneBtn];
            
            bgView.height = versionLab.height+contentHeight+15+40;
            bgView.center = self.center;
        }
    }
}

#pragma mark - 取消点击
- (void)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    if (!_dontDissmiss) {
        [self dismissAlert];
    }
}

-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss=dontDissmiss;
}

#pragma mark - 确定点击
- (void)doneAction:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
    
    [self dismissAlert];
}

#pragma mark - 页面消失
- (void)dismissAlert
{
    [self removeFromSuperview];
    bgView.hidden = YES;
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - 设置弹框动画效果
-(void)setAnimationStyle:(AShowAnimationStyle)animationStyle{
    [bgView setShowAnimationWithStyle:animationStyle];
}

@end
