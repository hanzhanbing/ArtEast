//
//  DefaultView.m
//  ArtEast
//
//  Created by yibao on 16/11/3.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "DefaultView.h"

@implementation DefaultView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PageColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retry)];
        [self addGestureRecognizer:tap];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2-100, WIDTH, 200)];
        [self addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-50, 0, 100, 86.5)];
        [bgView addSubview:_imgView];
    
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame)+25, WIDTH, 20)];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        [bgView addSubview:_lab];
    }
    return self;
}

#pragma mark - 刷新
- (void)retry {
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        [self.delegate refresh];
    }
}

@end
