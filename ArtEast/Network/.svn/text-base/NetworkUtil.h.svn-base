//
//  NetworkUtil.h
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RealReachability.h>

typedef enum
{
    NET_UNKNOWN = 0,    // 未知,无网络
    NET_WIFI    = 1,    // WIFI
    NET_WWAN    = 2,    // 移动网络
    NET_2G      = 3,    // 2G
    NET_3G      = 4,    // 3G
    NET_4G      = 5,    // 4G
}NetworkType;


@interface NetworkUtil : NSObject

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (NetworkType )currentNetworkStatus;

/**
 *  网络实时监听
 */
- (void)listening;

+ (NetworkUtil *)sharedInstance;

@end
