//
//  NSTimer+eocBlockSupports.m
//  ArtEast
//
//  Created by zyl on 17/3/3.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NSTimer+eocBlockSupports.h"

@implementation NSTimer (eocBlockSupports)

+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat{
    return  [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:repeat];
}

//定时器所执行的方法
+(void)startTimer:(NSTimer *)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
