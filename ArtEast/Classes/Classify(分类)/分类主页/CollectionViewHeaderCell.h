//
//  CollectionViewHeaderCell.h
//  ArtEast
//
//  Created by yibao on 2017/2/20.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CollectionViewHeaderCell @"CollectionViewHeaderCell"

@interface CollectionViewHeaderCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;

@end
