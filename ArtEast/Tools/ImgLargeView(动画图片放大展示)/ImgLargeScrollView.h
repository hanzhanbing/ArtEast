//
//  ImgLargeScrollView.h
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgScrollView.h"
#import "TapImageView.h"

@interface ImgLargeScrollView : UIView<UIActionSheetDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>

+ (id)shareInstance;
- (void) tapImg:(NSMutableArray *)imgViewArr andIndex:(int)index;

@end
