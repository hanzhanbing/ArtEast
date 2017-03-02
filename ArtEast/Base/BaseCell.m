//
//  BaseCell.m
//  ArtEast
//
//  Created by yibao on 2016/11/1.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (UIViewController*)viewController {

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//获取导航控制器

- (UINavigationController*)navigationController {

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

@end
