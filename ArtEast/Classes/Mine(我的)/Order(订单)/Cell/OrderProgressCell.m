//
//  OrderProgressCell.m
//  ArtEast
//
//  Created by yibao on 16/11/9.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "OrderProgressCell.h"

@implementation OrderProgressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, WIDTH-50, 50)];
    _contextLabel.font = [UIFont systemFontOfSize:14];
    _contextLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    _contextLabel.numberOfLines = 0;
    
    _contextLabel.textAlignment =  NSTextAlignmentJustified;
    [self.contentView addSubview:_contextLabel];
    
    _ftimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_contextLabel.frame)+5, WIDTH-50, 13)];
    _ftimeLabel.textColor = PlaceHolderColor;
    _ftimeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_ftimeLabel];
    
    _dian = [[UILabel alloc]init];
    _dian.layer.cornerRadius = 8/2;
    _dian.layer.masksToBounds = YES;
    _dian.backgroundColor = [UIColor colorWithWhite:0.525 alpha:1.000];
    [self.contentView addSubview:_dian];
    
    _img = [[UIImageView alloc]init];
    _img.backgroundColor = [UIColor redColor];
    _img.hidden = YES;
    [self.contentView addSubview:_img];
    
    
    _line = [[UILabel alloc]init];
    _line.backgroundColor = [UIColor colorWithWhite:0.537 alpha:1.000];
    [self.contentView addSubview:_line];
}

@end
