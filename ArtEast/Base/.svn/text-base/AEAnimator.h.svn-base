//
//  AEAnimator.h
//  ArtEast
//
//  Created by zyl on 16/12/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AEAnimatorDelegate <NSObject>

- (void)animationFinish;

@end

@interface AEAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGRect destinationRec;
@property (nonatomic,assign) CGRect originalRec;
@property (nonatomic,assign) BOOL isPush;
@property (nonatomic,assign) id<AEAnimatorDelegate>delegate;

@end
