//
//  PageAnimationView.m
//  ArtEast
//
//  Created by Jason on 2018/4/10.
//  Copyright © 2018年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "PageAnimationView.h"

@implementation PageAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)setContentX:(CGFloat)contentX{
    
    _contentX = contentX;
    _imageView.frame = CGRectMake(contentX, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
