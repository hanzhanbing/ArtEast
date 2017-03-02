//
//  WelfareCenterView.h
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  福利中心
 *
 */

#import <UIKit/UIKit.h>

@class AEImages;
typedef void (^welfareBlock)(AEImages *images);

@interface WelfareCenterView : UICollectionReusableView

@property (nonatomic,copy) welfareBlock welfareBlock; //福利中心
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
