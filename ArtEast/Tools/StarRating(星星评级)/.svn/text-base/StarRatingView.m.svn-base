//
//  StarRatingView.m
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "StarRatingView.h"

#define kImageCount     5

#define kImageSpace_B         8.0

#define kImageWidth_B         20.0
#define kImageHeight_B        20.0

#define kStarImageBlank_B     @"GrayStar"
#define kStarImageFull_B      @"YellowStar"
#define kStarImageHalf_B      @"comment_star_yellow_half_big"

#define kImageSpace_S         0.0

#define kImageWidth_S         14.0
#define kImageHeight_S        14.0

#define kStarImageBlank_S     @"GrayStar"
#define kStarImageFull_S      @"YellowStar"
#define kStarImageHalf_S      @"comment_star_yellow_half"

@interface StarRatingView ()

@end

@implementation StarRatingView
{
    StarType     _type;
    CGFloat      _num; //星星数量
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:StarTypeSmall];
}

- (id)initWithFrame:(CGRect)frame type:(StarType)type
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:type];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number type:(StarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _numberOfStar = number;
        _type = type;
        
        self.rate = 0;
        self.editable = YES;
        
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNum:(CGFloat)num {
    self = [super initWithFrame:frame];
    if (self) {
        _num = num;
        self.topView = [[UIView alloc] init];
        self.topImgView = [[UIImageView alloc] init];
        self.bottomImgView = [[UIImageView alloc] init];
        [self showStar]; //显示星星
    }
    return self;
}

#pragma mark - 显示星星
- (void)showStar {
    CGRect frame = self.frame;
    frame.size.height = self.frame.size.width/6;
    self.frame = frame;
    CGFloat viewWidth = self.frame.size.width/19.1;
    self.bottomImgView.image = [UIImage imageNamed:@"star_empty"];
    CGRect bframe = self.bottomImgView.frame;
    bframe.size = self.frame.size;
    self.bottomImgView.frame = bframe;
    [self addSubview:self.bottomImgView];
    
    CGRect tframe = self.topImgView.frame;
    tframe.size = self.frame.size;
    self.topImgView.frame = tframe;
    self.topImgView.image = [UIImage imageNamed:@"star_full"];
    self.topImgView.clipsToBounds = true;
    
    CGRect tvframe = self.topView.frame;
    tvframe.size = self.frame.size;
    tvframe.size.width = _num*viewWidth*3+(int)_num*viewWidth;
    self.topView.frame = tvframe;
    [self.topView addSubview:self.topImgView];
    self.topView.clipsToBounds = true;
    [self addSubview:self.topView];
}

+ (float)defaultWidth
{
    return 120;
}

- (void)initSubviews
{
    CGRect frame = self.bounds;
    
    float imageWidth = (_type == StarTypeLarge) ? kImageWidth_B : kImageWidth_S;
    float imageSpace = (_type == StarTypeLarge) ? kImageSpace_B : kImageSpace_S;
    for (int i = 0; i < _numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * (imageWidth + imageSpace), 0, imageWidth, frame.size.height);
        imageView.tag = i + 1;
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        imageTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:imageTap];
    }
}

- (void)setRate:(float)rate
{
    if (rate < 0) {
        rate = 0;
    }
    if (rate > _numberOfStar) {
        rate = _numberOfStar;
    }
    
    _rate = rate;
    
    for (int i = 0; i < _numberOfStar; i ++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i + 1];
        if (imageView.tag <= _rate) {
            imageView.image = [self fullImage];
        }
        else {
            if ((float)imageView.tag - _rate <= 0.5) {
                imageView.image = [self halfImage];
            }
            else {
                imageView.image = [self blankImage];
            }
        }
    }
}

- (UIImage *)fullImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageFull_B : kStarImageFull_S];
}

- (UIImage *)halfImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageHalf_B : kStarImageHalf_S];
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageBlank_B : kStarImageBlank_S];
}

- (void)setEditable:(BOOL)editable
{
    self.userInteractionEnabled = editable;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    float tempRate = tap.view.tag;
    self.rate = tempRate;
    
    if ([self.delegate respondsToSelector:@selector(starRatingView:rateDidChange:)]) {
        [self.delegate starRatingView:self rateDidChange:self.rate];
    }
}

@end
