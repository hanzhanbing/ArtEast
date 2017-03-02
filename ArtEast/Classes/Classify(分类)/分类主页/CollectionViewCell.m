//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import "AETypeInfo.h"
#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-70)/2, 10, 70, 70)];
//        self.imageV.backgroundColor = PageColor;
//        self.imageV.layer.cornerRadius = self.imageV.frame.size.width/2;
//        [self.imageV.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, 95, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textColor = LightBlackColor;
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)setModel:(AESubTypeInfo *)model
{
    NSLog(@"djhgvuirtghiug%@",model.picture);
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    self.name.text = model.virtual_cat_name;
}

@end
