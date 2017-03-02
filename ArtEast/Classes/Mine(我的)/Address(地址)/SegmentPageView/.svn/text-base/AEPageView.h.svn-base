//
//  AEPageView.h
//  ArtEast
//
//  Created by yibao on 2016/12/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEPageView;

@protocol AEPageViewDataSource <NSObject>

- (NSInteger)numberOfItemInAEPageView:(AEPageView *)pageView;
- (UIView*)pageView:(AEPageView *)pageView viewAtIndex:(NSInteger)index;

@end

@protocol AEPageViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end


@interface AEPageView : UIView

@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,assign) NSInteger numberOfItems;
@property(nonatomic,assign) BOOL scrollAnimation;
@property(nonatomic,weak) id<AEPageViewDataSource> datasource;
@property(nonatomic,weak) id<AEPageViewDelegate> delegate;

- (void)reloadData;
- (void)changeToItemAtIndex:(NSInteger)index;

@end
