//
//  TapImageView.h
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNFocusImageItem;

@protocol TapImageViewDelegate <NSObject>

- (void) tappedWithObject:(id) sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, strong) id identifier;

@property (weak) id<TapImageViewDelegate> t_delegate;

@property (nonatomic,strong)SNFocusImageItem *imageItem;

@end
