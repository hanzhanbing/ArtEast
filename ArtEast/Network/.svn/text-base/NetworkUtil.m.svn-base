//
//  NetworkUtil.m
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NetworkUtil.h"

static NetworkUtil *_instance;

@implementation NetworkUtil

+ (NetworkUtil *)sharedInstance
{
    static dispatch_once_t predicate ;
    dispatch_once(&predicate , ^{
        _instance = [[NetworkUtil alloc] init];
    });
    return _instance;
}

+ (NetworkType )currentNetworkStatus
{
    NetworkType nNetworkType = NET_UNKNOWN; //默认无网
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable) // || status == RealStatusUnknown
    {
        nNetworkType = NET_UNKNOWN; //无网
    }
    
    if (status == RealStatusViaWiFi)
    {
        nNetworkType = NET_WIFI; //WiFi
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        nNetworkType = NET_WWAN; //移动网络
        
        if (accessType == WWANType2G)
        {
            nNetworkType = NET_2G; //2G
        }
        else if (accessType == WWANType3G)
        {
            nNetworkType = NET_3G; //3G
        }
        else if (accessType == WWANType4G)
        {
            nNetworkType = NET_4G; //4G
        }
    }
    
    return nNetworkType;
}

- (void)listening
{
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

- (void)networkChanged:(NSNotification *)note
{
    if ([NetworkUtil currentNetworkStatus]!=NET_UNKNOWN) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
    } else {     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
    }
}

- (void)dealloc
{
    [GLobalRealReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
