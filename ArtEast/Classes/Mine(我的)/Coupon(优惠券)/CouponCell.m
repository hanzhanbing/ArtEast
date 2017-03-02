//
//  CouponCell.m
//  ArtEast
//
//  Created by yibao on 2016/12/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCellView];
    }
    return self;
}

- (void)initWithCellView{
    
    //名称
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH-100, 20)];
    _nameLab.textColor = LightBlackColor;
    _nameLab.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_nameLab];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, _nameLab.maxY+15, 54, 1)];
    _lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    [self.contentView addSubview:_lineView];
    
    //优惠信息
    _youhuiLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _lineView.maxY+15, WIDTH-100, 20)];
    _youhuiLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _youhuiLab.font = kFont14Size;
    [self.contentView addSubview:_youhuiLab];
    
    //有效日期
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _youhuiLab.maxY+5, WIDTH-100, 20)];
    _timeLab.numberOfLines = 0;
    _timeLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _timeLab.font = kFont13Size;
    [self.contentView addSubview:_timeLab];
    
    //状态图片
    _statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-190, 0, 191/2, 145/2)];
    [self.contentView addSubview:_statusImgView];
    
    //状态视图
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH-80, 0, 80, 124)];
    _statusView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [self.contentView addSubview:_statusView];
    
    _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(40-8, 0, 20, 124)];
    _statusLab.numberOfLines = 0;
    _statusLab.textColor = [UIColor whiteColor];
    _statusLab.font = [UIFont systemFontOfSize:16];
    [_statusView addSubview:_statusLab];
}

- (void)setCouponModel:(CouponModel *)couponModel {
    _nameLab.text = couponModel.cpns_name;
    _youhuiLab.text = couponModel.desc;
    _timeLab.text = [NSString stringWithFormat:@"有效期：%@ —— %@",couponModel.from_time,couponModel.to_time];
    _statusLab.text = couponModel.STATUS;
    
    if ([couponModel.isget isEqualToString:@"0"]) {
        _statusLab.text = @"未领取";
    }
    
    if ([couponModel.isget isEqualToString:@"1"]) {
        _statusLab.text = @"已领取";
        _statusView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        _statusLab.textColor = [UIColor grayColor];
    }
    
    if ([couponModel.STATUS isEqualToString:@"可使用"]||[couponModel.isget isEqualToString:@"0"]) {
        _statusView.backgroundColor = LightYellowColor;
        _statusLab.textColor = [UIColor blackColor];
    }
    if ([couponModel.STATUS isEqualToString:@"已使用"]) {
        _statusImgView.image = [UIImage imageNamed:@"CouponUsed"];
    }
    if ([couponModel.STATUS isEqualToString:@"已过期"]) {
        _statusImgView.image = [UIImage imageNamed:@"CouponOld"];
    }
    
    if ([couponModel.STATUS isEqualToString:@"已使用"]||[couponModel.STATUS isEqualToString:@"已过期"]||[couponModel.isget isEqualToString:@"1"]) {
        _nameLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _youhuiLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _timeLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
}

+ (CGFloat)getHeight:(CouponModel *)couponModel {
    CGFloat height = 0;
    height += 124;
    return height;
}

@end
