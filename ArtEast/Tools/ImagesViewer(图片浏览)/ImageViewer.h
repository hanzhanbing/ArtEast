//
//  ImageViewer.h
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewer : UIView<UIScrollViewDelegate>
{
    UIScrollView *bgScrollView;
    UILabel *lable;
}

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray<NSString *> *)data tag:(NSInteger)tag;

- (instancetype)initWithFrame1:(CGRect)frame andData:(NSArray<NSData *> *)data tag:(NSInteger)tag;

- (instancetype)initWithFrame:(CGRect)frame andUrlArr:(NSArray *)urlArr tag:(NSInteger)tag;

@end
