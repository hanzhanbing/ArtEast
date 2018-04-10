//
//  PageAnimationView.h
//  ArtEast
//
//  Created by Jason on 2018/4/10.
//  Copyright © 2018年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageAnimationView : UIView

@property (nonatomic, strong) UIImageView * imageView;

/**
 imageView的横坐标 用于拖拽过程中的动画
 */
@property (nonatomic, assign) CGFloat contentX;

@end
