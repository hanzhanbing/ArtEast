//
//  GridListCell.m
//  ArtEast
//
//  Created by yibao on 16/11/29.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GridListCell.h"
#import "GoodsModel.h"
#import "UIImageView+WebCache.h"

@interface GridListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rowLineLabel;
@property (nonatomic, strong) UILabel *colLineLabel;

@end

@implementation GridListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    //_imageV.backgroundColor = PageColor;
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.textColor = PriceColor;
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    
    _collectBtn = [[AEEmitterButton alloc] initWithFrame:CGRectMake(self.width-40, self.height-40, 30, 30)];
    [_collectBtn setImage:[UIImage imageNamed:@"CollectGray"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"CollectRed"] forState:UIControlStateSelected];
    [self.contentView addSubview:_collectBtn];
    
    //竖线
    _colLineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _colLineLabel.backgroundColor = LineColor;
    _colLineLabel.alpha = 0.6;
    [self.contentView addSubview:_colLineLabel];
    
    //横线
    _rowLineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rowLineLabel.backgroundColor = LineColor;
    _rowLineLabel.alpha = 0.6;
    [self.contentView addSubview:_rowLineLabel];
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        _imageV.frame = CGRectMake(30, 20, WIDTH/2-60, WIDTH/2-60);
        _titleLabel.frame = CGRectMake(10, _imageV.maxY+15, WIDTH/2-20, 20);
        _priceLabel.frame = CGRectMake(10, _titleLabel.maxY+5, WIDTH/2-20, 20);
        _collectBtn.frame = CGRectMake(self.width-40, self.height-40, 30, 30);
        
        _colLineLabel.frame = CGRectMake(WIDTH/2-0.1, 0, 0.2, self.height);
        _rowLineLabel.frame = CGRectMake(0, self.height-0.2, WIDTH/2, 0.2);
    } else {
        _imageV.frame = CGRectMake(5, 5, self.bounds.size.height - 10, self.bounds.size.height - 10);
        _titleLabel.frame = CGRectMake(self.bounds.size.height + 10, 0, WIDTH/2, self.bounds.size.height - 20);
        _priceLabel.frame = CGRectMake(self.bounds.size.height + 10, self.bounds.size.height - 30, WIDTH/2, 20);
    }
}

- (void)setModel:(GoodsModel *)model
{
    _model = model;

    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    
    if ([model.favoroite isEqualToString:@"1"]) { //关注
        _collectBtn.selected = YES;
    } else {
        _collectBtn.selected = NO;
    }
}

@end
