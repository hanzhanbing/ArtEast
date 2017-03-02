//
//  GoodsListCell.m
//  ArtEast
//
//  Created by yibao on 16/12/9.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsListCell.h"

@implementation GoodsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCellView];
    }
    return self;
}

- (void)initWithCellView{
    //图片
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 100, 100)];
    self.imageV.contentMode = UIViewContentModeScaleToFill;
    self.imageV.clipsToBounds = YES;
    [self.contentView addSubview:self.imageV];
    
    //名称
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame)+10, 10, WIDTH-140, 20)];
    _nameLab.textColor = LightBlackColor;
    _nameLab.font = kFont14Size;
    [self.contentView addSubview:_nameLab];
    
    //简介
    _briefLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame)+10, _nameLab.maxY+8, WIDTH-140, 40)];
    _briefLab.numberOfLines = 2;
    _briefLab.textColor = PlaceHolderColor;
    _briefLab.font = kFont12Size;
    [self.contentView addSubview:_briefLab];
    
    //价格
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame)+10, 90, 150, 20)];
    _priceLab.textColor = PriceColor;
    _priceLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_priceLab];
    
    //市场价格
    //    _mktpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(_priceLab.maxX+10, 90, 90, 20)];
    //    _mktpriceLab.textColor = PlaceHolderColor;
    //    _mktpriceLab.font = kFont12Size;
    //    [self.contentView addSubview:_mktpriceLab];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel {
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.icon] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    _nameLab.text = goodsModel.name;
    _briefLab.text = goodsModel.brief;
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",goodsModel.price];
    _priceLab.text = priceStr;
    CGSize sizeToFit = [priceStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName,nil] context:nil].size;
    _priceLab.width = sizeToFit.width;
    _mktpriceLab.frame = CGRectMake(_priceLab.maxX+8, 91, 100, 20);
    NSString *mktpriceStr = [NSString stringWithFormat:@"￥%@",goodsModel.mktprice];
    [Utils addDeleteLine:_mktpriceLab andContent:mktpriceStr andRang:NSMakeRange(0,mktpriceStr.length)];
}

+ (CGFloat)getHeight:(GoodsModel *)goodsModel {
    CGFloat height = 120;
    
    return height;
}

- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
