//
//  AEImages.m
//  ArtEast
//
//  Created by yibao on 16/11/29.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEImages.h"

@implementation AEImages

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"desc":@"description",
             };
}

- (void)setAd_img:(NSString *)ad_img {
    if (_ad_img != ad_img) {
        _ad_img = [NSString stringWithFormat:@"%@%@",PictureUrl,ad_img];
    }
}

- (void)setAd_url:(NSString *)ad_url {
    if (_ad_url != ad_url) {
        if ([ad_url containsString:@"http"]) {
            _ad_url = ad_url;
        } else {
            _ad_url = [NSString stringWithFormat:@"%@%@",WebUrl,ad_url];
        }
    }
}

@end
