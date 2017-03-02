//
//  AESegment.m
//  ArtEast
//
//  Created by yibao on 2016/12/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AESegment.h"
@interface AESegment(){
    NSArray *widthArray;
    NSInteger _allButtonW;
}

@end

@implementation AESegment

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.clipsToBounds = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _divideView = [[UIView alloc] init];
        _divideView.backgroundColor = AppThemeColor;
        [_scrollView addSubview:_divideView];
    }
    
    return self;
}

-(UIFont*)textFont{
    return _textFont?:kFont14Size;
}

- (void)updateChannels:(NSArray*)array andIndex:(NSInteger)index {
    
    for(UIView *view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSMutableArray *widthMutableArray = [NSMutableArray array];
    NSInteger totalW = 0;
    for (int i = 0; i < array.count; i++) {
        
        NSString *string = [array objectAtIndex:i];
        if (string.length>4) {
            string = [string substringToIndex:3];
            string = [string stringByAppendingString:@"..."];
        }
        
        CGFloat buttonW = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size.width + 30;
        [widthMutableArray addObject:@(buttonW)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalW, 0, buttonW, self.bounds.size.height)];
        button.tag = 1000 + i;
        [button.titleLabel setFont:self.textFont];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setTitle:string forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        if (i == index) {
            [button setSelected:YES];
            _divideView.frame = CGRectMake(totalW+15, _scrollView.bounds.size.height-2, buttonW-30, 2);
            _selectedIndex = index;
        } else {
            
            if ([string isEqualToString:@"城市"]||[string isEqualToString:@"区县"]) {
                button.userInteractionEnabled = NO;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            } else {
                button.userInteractionEnabled = YES;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        
        totalW += buttonW;
    }
    
    _allButtonW = totalW;
    _scrollView.contentSize = CGSizeMake(totalW,0);
    widthArray = [widthMutableArray copy];
}

- (void)clickSegmentButton:(UIButton*)selectedButton{
    
    UIButton *oldSelectButton = (UIButton*)[_scrollView viewWithTag:(1000 + _selectedIndex)];
    [oldSelectButton setSelected:NO];
    [selectedButton setSelected:YES];
    
    _selectedIndex = selectedButton.tag - 1000;
    if ([_delegate respondsToSelector:@selector(AESegment:didSelectIndex:)]) {
        [_delegate AESegment:self didSelectIndex:_selectedIndex];
    }
    
    NSInteger totalW = 0;
    for (int i=0; i<_selectedIndex; i++) {
        totalW += [[widthArray objectAtIndex:i] integerValue];
    }
    //处理边界
    CGFloat selectW = [[widthArray objectAtIndex:_selectedIndex] integerValue];
    //滑块
    [UIView animateWithDuration:0.1 animations:^{
        _divideView.frame = CGRectMake(totalW+15, _divideView.frame.origin.y, selectW-30, _divideView.frame.size.height);
    }];
}

- (void)didChengeToIndex:(NSInteger)index{
    
    UIButton *selectedButton = [_scrollView viewWithTag:(1000 + index)];
    [self clickSegmentButton:selectedButton];
}

@end
