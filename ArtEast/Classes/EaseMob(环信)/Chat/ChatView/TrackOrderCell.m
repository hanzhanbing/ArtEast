//
//  TrackOrderCell.m
//  ArtEast
//
//  Created by zyl on 17/1/21.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "TrackOrderCell.h"

@interface TrackOrderCell ()
{
//    UILabel *_titleLab;
    UILabel *_orderNumLab;
    UIImageView *_imageView;
    UILabel *_nameLab;
    UILabel *_priceLab;
    
    UILabel *_nickLab;
    UIImageView *_headImageView;
}
@end

@implementation TrackOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContentView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addContentView {
    
    _nickLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-70, 0, WIDTH/2+10, 12)];
    _nickLab.hidden = YES;
    _nickLab.font = [UIFont systemFontOfSize:10];
    _nickLab.textColor = [UIColor grayColor];
    _nickLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_nickLab];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-50, 13, 40, 40)];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    [_headImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_headImageView];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_white_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    [self.contentView addSubview:_bgImageView];
    
//    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
//    _titleLab.font = [UIFont systemFontOfSize:15];
//    [_bgImageView addSubview:_titleLab];
    
    _orderNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _orderNumLab.font = [UIFont systemFontOfSize:14];
    [_bgImageView addSubview:_orderNumLab];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_bgImageView addSubview:_imageView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.numberOfLines = 2;
    [_bgImageView addSubview:_nameLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = PriceRedColor;
    [_bgImageView addSubview:_priceLab];
}

- (void)setInfo:(NSMutableDictionary *)info {
    _nickLab.text = info[@"nick"];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:info[@"avatar"]] placeholderImage:[UIImage imageNamed:@"MineHeadIcon"]];
//    _titleLab.text = info[@"title"];
    if ([info[@"type"] isEqualToString:@"订单"]) {
        _orderNumLab.hidden = NO;
        _orderNumLab.text = info[@"order_title"];
        
        _bgImageView.frame = CGRectMake(WIDTH/2-100, 15, WIDTH/2+40, 115);
//        _titleLab.frame = CGRectMake(10, 15, 100, 15);
        _orderNumLab.frame = CGRectMake(15, 15, WIDTH/2-10, 15);
        _imageView.frame = CGRectMake(15, _orderNumLab.maxY+10, 60, 60);
        CGSize nameSize = [info[@"desc"] boundingRectWithSize:CGSizeMake(WIDTH/2-60,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil] context:nil].size;
        _nameLab.frame = CGRectMake(_imageView.maxX+10, _orderNumLab.maxY+10, WIDTH/2-60, nameSize.height>40?40:nameSize.height);
        _priceLab.frame = CGRectMake(_imageView.maxX+10, _imageView.maxY-15, WIDTH/2-60, 15);
    } else {
        _orderNumLab.hidden = YES;
        _bgImageView.frame = CGRectMake(WIDTH/2-100, 15, WIDTH/2+40, 90);
//        _titleLab.frame = CGRectMake(10, 15, 100, 15);
        _imageView.frame = CGRectMake(15, 15, 60, 60);
        CGSize nameSize = [info[@"desc"] boundingRectWithSize:CGSizeMake(WIDTH/2-60,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil] context:nil].size;
        _nameLab.frame = CGRectMake(_imageView.maxX+10, 15, WIDTH/2-60, nameSize.height>40?40:nameSize.height);
        _priceLab.frame = CGRectMake(_imageView.maxX+10, _imageView.maxY-15, WIDTH/2-60, 15);
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:info[@"img_url"]] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    _nameLab.text = info[@"desc"];
    _priceLab.text = info[@"price"];
}

+ (CGFloat)getHeight:(NSMutableDictionary *)info {
    return 0;
}

@end
