//
//  TrackOrderCell.h
//  ArtEast
//
//  Created by zyl on 17/1/21.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  轨迹/订单自定义Cell
 *
 */

#import <UIKit/UIKit.h>

@interface TrackOrderCell : UITableViewCell

@property (nonatomic,retain) NSMutableDictionary *info;

+ (CGFloat)getHeight:(NSMutableDictionary *)info;

@property (nonatomic,retain) UIImageView *bgImageView;

@end
