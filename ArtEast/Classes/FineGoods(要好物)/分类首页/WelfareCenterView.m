//
//  WelfareCenterView.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "WelfareCenterView.h"
#import "AEImages.h"

@interface WelfareCenterView ()

@property (nonatomic,strong) UIButton *imageBtn;

@end

@implementation WelfareCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, WIDTH-24, 80)];
        [_imageBtn addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageBtn];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count>0) {
        AEImages *images = _dataSource[0];
        
        [_imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:images.ad_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ClassifyDefaultIcon"]];
    }
}

#pragma mark - 跳转到福利中心

- (void)jumpAction {
    if (self.welfareBlock) {
        AEImages *images = _dataSource[0];
        self.welfareBlock(images);
    }
}

@end
