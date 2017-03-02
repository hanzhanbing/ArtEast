//
//  BannerView.h
//  ArtEast
//
//  Created by yibao on 2017/2/16.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  广告图片轮播
 *
 */

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@class AEImages;

typedef void (^BannerBlock) (AEImages *images);

@interface BannerView : UICollectionReusableView<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_cycleScrollView;
}

@property (nonatomic,copy) BannerBlock bannerBlock;
@property (nonatomic,strong) NSMutableArray *bannerArr;//bannerArr存放图片url

@end
