//
//  UITabBar+BadgeValue.h
//  ArtEast
//
//  Created by yibao on 2017/1/24.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (BadgeValue)

- (void)showBadgeOnItemIndex:(NSInteger)index andCount:(NSString *)count; //显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end
