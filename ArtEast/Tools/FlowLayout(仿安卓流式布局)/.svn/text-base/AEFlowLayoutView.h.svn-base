//
//  AEFlowLayoutView.h
//  ArtEast
//
//  Created by yibao on 16/10/25.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEButton.h"

#define TopSPACE 10 //距离顶部距离
#define LeftSPACE 15 //距离左边距离
#define SPACE 15 //间距

@protocol AEFlowLayoutViewDelegate <NSObject>

- (void)clickFlowLayout:(AEButton *)btn;

@end

@interface AEFlowLayoutView : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) int select_index;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) id<AEFlowLayoutViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andDefaultIndex:(int)index;

@end
