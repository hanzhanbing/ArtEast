//
//  AEFlowLayoutView.m
//  ArtEast
//
//  Created by yibao on 16/10/25.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEFlowLayoutView.h"
#import "AEButton.h"

@implementation AEFlowLayoutView

- (instancetype)initWithFrame:(CGRect)frame andDefaultIndex:(int)index {
    if (self = [super initWithFrame:frame]) {
        self.select_index = index;
    }
    return self;
}

- (void)setArray:(NSMutableArray *)array {
    if (_array != array) {
        _array = array;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGSize size = CGSizeMake(LeftSPACE, 45+TopSPACE);
        CGFloat width = WIDTH-30;
        for (int i = 0; i < _array.count; i ++) {
            CGFloat keyWorldWidth = [Utils getSizeByString:array[i] AndFontSize:14].width;
            keyWorldWidth = keyWorldWidth +5;
            if (keyWorldWidth > width) {
                keyWorldWidth = width;
            }
            if (width - size.width < keyWorldWidth) {
                size.height += 45.0;
                size.width = LeftSPACE;
            }
            //创建 label点击事件
            AEButton *button = [[AEButton alloc]initWithFrame:CGRectMake(size.width, size.height-40, keyWorldWidth, 30)];
            button.titleLabel.numberOfLines = 0;
            button.layer.borderColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0].CGColor;
            button.layer.borderWidth = 1;
            button.cornerRadius = 2;
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont12Size;
            [button setTitle:_array[i] forState:UIControlStateNormal];
            [self addSubview:button];
            button.idStr = [NSString stringWithFormat:@"%d",i];
            button.name = _array[i];
            button.tag = 1000+i;
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            if (_isSelected == YES&&i==self.select_index) {
                [button setTitleColor:AppThemeColor forState:UIControlStateNormal];
                button.layer.borderColor = AppThemeColor.CGColor;
            }
            //起点 增加
            size.width += keyWorldWidth+SPACE;
        }
        self.height = size.height+TopSPACE-5;
    }
}

- (void)click:(AEButton *)sender {
    if (_isSelected == YES) {
        AEButton *selectedBtn = (AEButton *)sender;
        int index = (int)selectedBtn.tag;
        for (int i = 0; i < _array.count; i ++) {
            AEButton *normalBtn = [self viewWithTag:1000+i];
            if (index == normalBtn.tag) { //选中
                [normalBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
                normalBtn.layer.borderColor = AppThemeColor.CGColor;
            } else {
                [normalBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                normalBtn.layer.borderColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0].CGColor;
            }
        }
    }

    if([self.delegate respondsToSelector:@selector(clickFlowLayout:)]){
        [self.delegate clickFlowLayout:sender];
    }
}

@end
