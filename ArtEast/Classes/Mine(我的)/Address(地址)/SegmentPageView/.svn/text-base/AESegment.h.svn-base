//
//  AESegment.h
//  ArtEast
//
//  Created by yibao on 2016/12/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AESegment;

@protocol AESegmentDelegate <NSObject>

- (void)AESegment:(AESegment*)segment didSelectIndex:(NSInteger)index;

@end


@interface AESegment : UIControl

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *divideView;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,weak) id<AESegmentDelegate> delegate;

- (void)updateChannels:(NSArray*)array andIndex:(NSInteger)index;
- (void)didChengeToIndex:(NSInteger)index;

@end
