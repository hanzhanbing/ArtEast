//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, 60, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = [UIColor grayColor];
        self.name.highlightedTextColor = LightYellowColor;
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];

        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, 3, 30)];
        self.yellowView.backgroundColor = LightYellowColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor whiteColor];
    self.name.font = selected ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:15];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
