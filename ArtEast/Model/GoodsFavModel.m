//
//  GoodsFavModel.m
//  ArtEast
//
//  Created by yibao on 2017/2/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsFavModel.h"

@implementation GoodsFavModel

- (void)setAvatar:(NSString *)avatar {
    if (_avatar != avatar) {
        if ([avatar containsString:@"http"]) {
            _avatar = avatar;
        } else {
            _avatar = [NSString stringWithFormat:@"%@%@",PictureUrl,avatar];
        }
    }
}

@end
