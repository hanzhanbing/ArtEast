//
//  GoodsCollectionCell.h
//  ArtEast
//
//  Created by yibao on 2017/2/14.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsCollectionCell : UITableViewCell
{
    UILabel *_nameLab;
    UILabel *_briefLab;
    UILabel *_priceLab;
    UILabel *_mktpriceLab;
}

@property (nonatomic, retain)UIButton *moreBtn;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic, retain)GoodsModel *goodsModel;

+ (CGFloat)getHeight:(GoodsModel *)goodsModel;

@end
