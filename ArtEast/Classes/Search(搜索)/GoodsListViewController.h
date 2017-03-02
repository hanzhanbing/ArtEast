//
//  GoodsListViewController.h
//  ArtEast
//
//  Created by yibao on 16/11/22.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  商品列表
 *
 */

#import "BaseVC.h"
#import "GoodsModel.h"

@interface GoodsListTableCell : UITableViewCell
{
    UIView  *_whiteBg;
    UILabel *_nameLab;
    UILabel *_briefLab;
    UILabel *_priceLab;
    UILabel *_mktpriceLab;
    UIView  *_lineView;
}

@property (nonatomic, retain)UIButton *jumpBtn;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic, retain)GoodsModel *goodsModel;

+ (CGFloat)getHeight:(GoodsModel *)goodsModel;

@end


@interface GoodsListViewController : BaseVC

@property (nonatomic,copy) NSString *virtual_cat_name;
@property (nonatomic,copy) NSString *virtual_cat_id;
@property (nonatomic,copy) NSString *search_content;

@end
