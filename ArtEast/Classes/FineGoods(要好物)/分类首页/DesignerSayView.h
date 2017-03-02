//
//  DesignerSayView.h
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  设计师说
 *
 */

#import <UIKit/UIKit.h>

@class AEImages;
typedef void (^SayBlock) (AEImages *images);

@interface DesignerSayView : UICollectionReusableView

@property (nonatomic,copy) SayBlock sayBlock; //跳转到设计师说
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
