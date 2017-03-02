//
//  TapImageView.m
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

- (void)dealloc
{
    _t_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        [self addGestureRecognizer:tap];
        
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) Tapped:(UIGestureRecognizer *) gesture
{
    if ([self.t_delegate respondsToSelector:@selector(tappedWithObject:)])
    {
        [self.t_delegate tappedWithObject:self];
    }
}


@end
