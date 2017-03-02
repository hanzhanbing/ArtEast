//
//  StarRatingView.h
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StarTypeSmall,
    StarTypeLarge,
} StarType;

@class StarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate;

@end

@interface StarRatingView : UIView

- (id)initWithFrame:(CGRect)frame type:(StarType)type;
- (id)initWithFrame:(CGRect)frame andNum:(CGFloat)num;

+ (float)defaultWidth;

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic) float rate;
@property (nonatomic) BOOL editable;            // default is YES

@property (nonatomic,retain) UIView *topView;
@property (nonatomic,retain) UIImageView *topImgView;
@property (nonatomic,retain) UIImageView *bottomImgView;

@end
