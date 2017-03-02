//
//  AETypeInfo.m
//  ArtEast
//
//  Created by yibao on 16/10/18.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AETypeInfo.h"

@implementation AETypeInfo

+(NSDictionary *)objectClassInArray
{
    return @{@"childs":[AESubTypeInfo class]};
}

- (void)setPicture:(NSString *)picture {
    if (_picture != picture) {
        _picture = [NSString stringWithFormat:@"%@%@",PictureUrl,picture];
    }
}

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = [NSString stringWithFormat:@"%@%@",PictureUrl,url];
    }
}

@end
