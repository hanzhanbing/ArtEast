//
//  DesignerSayView.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "DesignerSayView.h"
#import "AEImages.h"

@interface DesignerSayView ()

@property (nonatomic,strong) UIButton *imageBtn;

@end

@implementation DesignerSayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/2)];
        [_imageBtn addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageBtn];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count>0) {
        AEImages *images = _dataSource[0];
        
        [_imageBtn sd_setImageWithURL:[NSURL URLWithString:images.ad_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ClassifyDefaultIcon"]];
    }
}

#pragma mark - 跳转到设计师说

- (void)jumpAction {
    if (self.sayBlock) {
        AEImages *images = _dataSource[0];
        self.sayBlock(images);
    }
}

@end
