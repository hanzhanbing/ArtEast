//
//  GoodsModel.m
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"goods_id",
             @"icon":@"picture",
             @"favoroite":@"isFav",
             };
}

- (void)setName:(NSString *)name {
    if (_name != name) {
        _name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (void)setIcon:(NSString *)icon {
    if (_icon != icon) {
        if (![icon containsString:@"http"]) {
            _icon = [NSString stringWithFormat:@"%@%@",PictureUrl,icon];
        } else {
            _icon = icon;
        }
    }
}

- (void)setS_url:(NSString *)s_url {
    if (_s_url != s_url) {
        if (![_s_url containsString:@"http"]) {
            _s_url = [NSString stringWithFormat:@"%@%@",PictureUrl,s_url];
        } else {
            _s_url = s_url;
        }
        if ([_s_url containsString:@"http"]) {
            _icon = _s_url;
        }
    }
}

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = [NSString stringWithFormat:@"%@%@",PictureUrl,url];
    }
}

@end
