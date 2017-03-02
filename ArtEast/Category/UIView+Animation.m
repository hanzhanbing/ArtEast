//
//  UIView+Animation.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)setShowAnimationWithStyle:(AShowAnimationStyle)animationStyle {
    switch (animationStyle) {
            
        case ASAnimationDefault:
        {
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.layer setValue:@(0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [self.layer setValue:@(.9) forKeyPath:@"transform.scale"];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [self.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case ASAnimationLeftShake:{
            
            CGPoint startPoint = CGPointMake(-CGRectGetWidth(self.frame), self.center.y);
            self.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.layer.position=[UIApplication sharedApplication].keyWindow.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case ASAnimationTopShake:{
            
            CGPoint startPoint = CGPointMake(self.center.x, -self.frame.size.height);
            self.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.layer.position=[UIApplication sharedApplication].keyWindow.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case ASAnimationNO:{
            
        }
            
            break;
            
        default:
            break;
    }
}

@end
