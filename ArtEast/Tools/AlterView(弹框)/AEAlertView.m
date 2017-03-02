//
//  AEAlertView.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#define MainScreenRect [UIScreen mainScreen].bounds
#define AlertView_W     270.0f
#define MessageMin_H    60.0f       //messagelab的最小高度
#define MessageMAX_H    120.0f      //messagelab的最大高度，当超过时，文本会以...结尾
#define ATitle_H      20.0f
#define ABtn_H        30.0f

#define SFQBlueColor        [UIColor colorWithRed:9/255.0 green:170/255.0 blue:238/255.0 alpha:1]
#define SFQRedColor         [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define SFQLightGrayColor   [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#define ADTitleFont       [UIFont boldSystemFontOfSize:17];
#define ADMessageFont     [UIFont systemFontOfSize:14];
#define ADBtnTitleFont    [UIFont systemFontOfSize:15];



#import "AEAlertView.h"
#import "UILabel+Add.h"
#import "UIImage+Color.h"
#import "UIView+Animation.h"

@interface AEAlertView()
@property (nonatomic,strong)UIWindow *alertWindow;
@property (nonatomic,strong)UIView *alertView;

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *otherBtn;
@end

@implementation AEAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(AlertClickIndexBlock)block{
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=6.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        
        if (title) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, AlertView_W, ATitle_H)];
            _titleLab.text=title;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=[UIColor blackColor];
            _titleLab.font=ADTitleFont;
            
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.text=message;
        _messageLab.textColor=[UIColor lightGrayColor];
        _messageLab.font=ADMessageFont;
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+10, AlertView_W-messageLabSpace*2, endMessageLabH);
        
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+ATitle_H+ABtn_H+40);
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cancelTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:SFQLightGrayColor] forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font=ADBtnTitleFont;
            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_cancelBtn];
        }
        
        if (otherBtnTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=ADBtnTitleFont;
            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            [_otherBtn setBackgroundImage:[UIImage imageWithColor:SFQRedColor] forState:UIControlStateNormal];
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }
        
        CGFloat btnLeftSpace = 40;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-40;
        if (cancelTitle && !otherBtnTitle) {
            _cancelBtn.tag=0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, ABtn_H);
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, ABtn_H);
        }else if (cancelTitle && otherBtnTitle){
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 20;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, ABtn_H);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, ABtn_H);
        }
        
        self.clickBlock=block;
        
    }
    return self;
}


-(void)btnClick:(UIButton *)btn{
    
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
    
}

-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss=dontDissmiss;
}

-(void)showAlertView{
    
    _alertWindow=[[UIWindow alloc] initWithFrame:MainScreenRect];
    _alertWindow.windowLevel=UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    
    [_alertWindow addSubview:self];
}

-(void)dismissAlertView{
    [self removeFromSuperview];
    [_alertWindow resignKeyWindow];
}

#pragma mark - 设置弹框动画效果
-(void)setAnimationStyle:(AShowAnimationStyle)animationStyle{
    [_alertView setShowAnimationWithStyle:animationStyle];
}

@end
