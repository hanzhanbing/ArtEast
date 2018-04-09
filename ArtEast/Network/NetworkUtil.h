//
//  NetworkUtil.h
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkUtil : NSObject

@property (nonatomic) Reachability *hostReachability;

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (NetworkStatus)currentNetworkStatus;

/**
 *  网络实时监听
 */
- (void)listening;

+ (NetworkUtil *)sharedInstance;

@end
