//
//  GoodsCommentModel.m
//  ArtEast
//
//  Created by yibao on 16/12/9.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsCommentModel.h"

@implementation GoodsCommentModel

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = [NSString stringWithFormat:@"%@%@",PictureUrl,url];
    }
}

@end
