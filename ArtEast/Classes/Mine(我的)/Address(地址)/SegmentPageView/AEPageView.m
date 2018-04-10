//
//  AEPageView.m
//  ArtEast
//
//  Created by yibao on 2016/12/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEPageView.h"

@interface AEPageView()<UIScrollViewDelegate>{
    NSInteger _currentIndex;
    NSInteger _lastPosition; //判断左右滑动
    BOOL isRight; //是否向右滑动
}

@property (nonatomic,strong) NSMutableArray *itemsArray;


@end


@implementation AEPageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
}

- (void)reloadData{
    if (nil != _datasource) {
        _numberOfItems = [_datasource numberOfItemInAEPageView:self];
        _scrollView.contentSize = CGSizeMake(_numberOfItems * self.frame.size.width,self.frame.size.height);
    }
}

- (void)changeToItemAtIndex:(NSInteger)index{
    
    if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
        [self loadViewAtIndex:index];
    }
    [_scrollView setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:_scrollAnimation];
    [self preLoadViewWithIndex:index];
    _currentIndex = index;
}

- (NSMutableArray*)itemsArray{
    
    if (_itemsArray == nil) {
        NSInteger total = [_datasource numberOfItemInAEPageView:self];
        _itemsArray = [NSMutableArray arrayWithCapacity:total];
        for (int i = 0; i < total; i++) {
            [_itemsArray addObject:[NSNull null]];
        }
    }
    return _itemsArray;
    
}

- (void)loadViewAtIndex:(NSInteger)index{
    if (_datasource != nil && [_datasource respondsToSelector:@selector(pageView:viewAtIndex:)]) {
        UIView *view = [_datasource pageView:self viewAtIndex:index];
        view.frame = CGRectMake(self.bounds.size.width*index, 0, self.bounds.size.width, self.bounds.size.height);
        [_scrollView addSubview:view];
        [self.itemsArray replaceObjectAtIndex:index withObject:view];
    }
}

- (void)preLoadViewWithIndex:(NSInteger)index{
    
    if (index > 0 && [self.itemsArray objectAtIndex:(index-1)] == [NSNull null]) {
        [self loadViewAtIndex:(index-1)];
    }
    if (index < (_numberOfItems-1) && [self.itemsArray objectAtIndex:(index+1)] == [NSNull null]) {
        [self loadViewAtIndex:(index+1)];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (isRight==YES) { //向右滑
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CityCountyCount"] isEqualToString:@"2"]) { //市区没选
            [_scrollView setContentOffset:CGPointMake(_currentIndex * self.bounds.size.width, 0) animated:_scrollAnimation];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CityCountyCount"] isEqualToString:@"1"]) { //区没选
            if (_currentIndex!=0) {
                [_scrollView setContentOffset:CGPointMake(_currentIndex * self.bounds.size.width, 0) animated:_scrollAnimation];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (isRight==NO) { //向左滑
        NSInteger index = scrollView.contentOffset.x / self.bounds.size.width;
        if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
            [self loadViewAtIndex:index];
        }
        [self preLoadViewWithIndex:index];
        
        if (index != _currentIndex) {
            if ([_delegate respondsToSelector:@selector(didScrollToIndex:)]) {
                [_delegate didScrollToIndex:index];
                _currentIndex = index;
            }
        }
    } else { //向右滑
        if ([Utils isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CityCountyCount"]]) { //省市区选完
            NSInteger index = scrollView.contentOffset.x / self.bounds.size.width;
            if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
                [self loadViewAtIndex:index];
            }
            [self preLoadViewWithIndex:index];
            
            if (index != _currentIndex) {
                if ([_delegate respondsToSelector:@selector(didScrollToIndex:)]) {
                    [_delegate didScrollToIndex:index];
                    _currentIndex = index;
                }
            }
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CityCountyCount"] isEqualToString:@"1"]) { //区没选
            if (_currentIndex==0) {
                NSInteger index = scrollView.contentOffset.x / self.bounds.size.width;
                if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
                    [self loadViewAtIndex:index];
                }
                [self preLoadViewWithIndex:index];
                
                if (index != _currentIndex) {
                    if ([_delegate respondsToSelector:@selector(didScrollToIndex:)]) {
                        [_delegate didScrollToIndex:index];
                        _currentIndex = index;
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.x;
    if (currentPostion - _lastPosition > 5) {
        _lastPosition = currentPostion;
        //NSLog(@"ScrollRight now");
        isRight = YES;
    }
    else if (_lastPosition - currentPostion > 5)
    {
        _lastPosition = currentPostion;
        //NSLog(@"ScrollLeft now");
        isRight = NO;
    }
}

@end
