//
//  ImgScrollView.h
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender; //点击
- (void) longPressImageViewTappedWithObject:(id) sender; //长按

@end

@interface ImgScrollView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@end
