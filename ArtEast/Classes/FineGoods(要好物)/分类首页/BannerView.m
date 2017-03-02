//
//  BannerView.m
//  ArtEast
//
//  Created by yibao on 2017/2/16.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BannerView.h"
#import "AEImages.h"

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-106-49-145) imageNamesGroup:@[@"GoodsDefaultBig"]];
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.delegate = self;
        //_cycleScrollView.pageDotColor = [UIColor grayColor];
        //_cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(12, 12); //分页控件小圆标大小
        [self addSubview:_cycleScrollView];
    }
    return self;
}

-(void)setBannerArr:(NSMutableArray *)bannerArr {
    if (_bannerArr != bannerArr)
    {
        _bannerArr = bannerArr;
        _cycleScrollView.imageURLStringsGroup = [self handleUrl];
    }
}

//设置轮播图
#pragma mark - SDCycleScrollViewDelegate代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    AEImages *images = _bannerArr[index];
    if (self.bannerBlock) {
        self.bannerBlock(images);
    }
}

#pragma mark - 处理 获取 图片的地址
- (NSArray *)handleUrl{
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *list = [NSMutableArray arrayWithArray:_bannerArr];
    
    for (int i = 0; i < list.count; i ++) {
        AEImages *info = list[i];
        [data addObject:info.ad_img];
    }
    return data;
}

@end
