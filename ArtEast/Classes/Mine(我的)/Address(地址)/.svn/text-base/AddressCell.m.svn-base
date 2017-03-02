//
//  AddressCell.m
//  ArtEast
//
//  Created by yibao on 16/12/22.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCellView];
    }
    return self;
}

- (void)initWithCellView{
    
    //名称
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH-140, 20)];
    _nameLab.textColor = LightBlackColor;
    _nameLab.font = kFont14Size;
    [self.contentView addSubview:_nameLab];
    
    //手机号
    _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, WIDTH-120, 20)];
    _phoneLab.textColor = LightBlackColor;
    _phoneLab.font = kFont14Size;
    [self.contentView addSubview:_phoneLab];
    
    //默认
    CGSize tagSize = [@"默认" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont13Size} context:nil].size;
    _defaultLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, tagSize.width+10, 20)];
    _defaultLab.numberOfLines = 0;
    _defaultLab.layer.cornerRadius = 2;
    [_defaultLab.layer setMasksToBounds:YES];
    _defaultLab.layer.borderWidth = 0.5;
    _defaultLab.layer.borderColor = AppThemeColor.CGColor;
    _defaultLab.textAlignment = NSTextAlignmentCenter;
    _defaultLab.textColor = AppThemeColor;
    _defaultLab.font = kFont13Size;
    [self.contentView addSubview:_defaultLab];
    
    //地址
    _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 45, WIDTH-150, 20)];
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _addressLab.font = kFont13Size;
    [self.contentView addSubview:_addressLab];
    
    //修改图标
    _changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-45, 0, 40, 40)];
    [_changeBtn setImage:[UIImage imageNamed:@"Write"] forState:UIControlStateNormal];
    [self.contentView addSubview:_changeBtn];
}

- (void)setAddressModel:(AddressModel *)addressModel {
    _nameLab.text = addressModel.name;
    _phoneLab.text = addressModel.mobile;
    _defaultLab.text = @"默认";
    
    if ([addressModel.def_addr isEqualToString:@"1"]) {
        _defaultLab.hidden = NO;
    } else {
        _defaultLab.hidden = YES;
    }
    
    NSString *addressStr = [NSString stringWithFormat:@"%@%@",addressModel.txt_area,addressModel.addr];
    _addressLab.text = addressStr;
    
    CGSize addressSize = [addressStr boundingRectWithSize:CGSizeMake(WIDTH-150,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont13Size} context:nil].size;
    _addressLab.height = addressSize.height;
    _changeBtn.centerY = (58+addressSize.height)/2;
}

+ (CGFloat)getHeight:(AddressModel *)addressModel {
    CGFloat height = 0;
    NSString *addressStr = [NSString stringWithFormat:@"%@%@",addressModel.txt_area,addressModel.addr];
    CGSize addressSize = [addressStr boundingRectWithSize:CGSizeMake(WIDTH-150, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont13Size} context:nil].size;
    height = 15+20+10+addressSize.height+15;
    NSLog(@"jrekgherhgo%f",height);
    return height;
}

@end
