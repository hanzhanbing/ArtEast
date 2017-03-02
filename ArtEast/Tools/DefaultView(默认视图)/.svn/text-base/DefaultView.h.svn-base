//
//  DefaultView.h
//  ArtEast
//
//  Created by yibao on 16/11/3.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshDelegate <NSObject>

- (void)refresh; //重新加载

@end

@interface DefaultView : UIView

@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,retain) UILabel *lab;

@property (nonatomic,assign) id<RefreshDelegate> delegate;

@end
