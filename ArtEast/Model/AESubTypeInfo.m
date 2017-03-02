//
//  AESubTypeInfo.m
//  ArtEast
//
//  Created by yibao on 16/10/18.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AESubTypeInfo.h"

@implementation AESubTypeInfo

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = [NSString stringWithFormat:@"%@%@",PictureUrl,url];
    }
}

- (void)setPicture:(NSString *)picture {
    if (_picture != picture) {
        _picture = [NSString stringWithFormat:@"%@%@",PictureUrl,picture];
    }
}

@end
