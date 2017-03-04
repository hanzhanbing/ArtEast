//
//  NSTimer+eocBlockSupports.h
//  ArtEast
//
//  Created by zyl on 17/3/3.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (eocBlockSupports) //类方法返回一个NSTimer的实例对象

+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat;

@end
