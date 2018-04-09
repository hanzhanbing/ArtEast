//
//  BaseNavBar.m
//  KKY
//
//  Created by Jason on 2018/4/8.
//  Copyright © 2018年 hzb. All rights reserved.
//

#import "BaseNavBar.h"

@implementation BaseNavBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (@available(iOS 11.0, *)) { //适配iOS11
        for (UIView *view in self.subviews) {
            //两个都要设置，还要判断是否为iPhone X
            if([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.frame = CGRectMake(0, 0, WIDTH, kNavBarH);
            } else if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                view.frame = CGRectMake(0, kStatusBarH, WIDTH, kNavBarH-kStatusBarH);
            }
        }
    }
}

@end
