//
//  ImgLargeScrollView.m
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ImgLargeScrollView.h"
#import "FXBlurView.h"

@interface ImgLargeScrollView ()
{
    UIScrollView *myScrollView;
    NSInteger currentIndex;
    
    UIView *markView;
    UIView *scrollPanel;
    
    UIImageView *saveImageView; //长按保存图片的视图
    UIActionSheet *saveImgSheet; //保存图片
}
@end

static ImgLargeScrollView *imgLargeScrollView = nil;

@implementation ImgLargeScrollView

+ (id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imgLargeScrollView = [[ImgLargeScrollView alloc] init];
    });
    return imgLargeScrollView;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initLargeScrollImage]; //初始化图片放大滑动展示视图
    }
    return self;
}

#pragma mark - 初始化图片放大滑动展示视图
- (void)initLargeScrollImage {
    scrollPanel = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollPanel]; //全屏显示
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.frame];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
}

#pragma mark - 处理传递过来的图片控件
/*
 * @param imgViewArr 图片控件数组
 * @param index 索引，第几张图片
 */
- (void) tapImg:(NSMutableArray *)imgViewArr andIndex:(int)index {
    
    NSString *picSaveInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PicSaveInfo"];
    if ([Utils isBlankString:picSaveInfo]) {
        [Utils showToast:@"长按可以保存图片哦"];
        [[NSUserDefaults standardUserDefaults] setObject:@"长按可以保存图片哦" forKey:@"PicSaveInfo"];
    }
    
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = [UIScreen mainScreen].bounds.size.height;
    contentSize.width = [UIScreen mainScreen].bounds.size.width * imgViewArr.count;
    myScrollView.contentSize = contentSize;
    
    [self bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = (TapImageView *)imgViewArr[index];
    currentIndex = index;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self];
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*WIDTH;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView:imgViewArr];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

#pragma mark - 在ScrollView上面添加图片
- (void) addSubImgView:(NSMutableArray *)tapImgViewArr
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < tapImgViewArr.count; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)tapImgViewArr[i];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark - UIScrollViewDelegate代理
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - ImgScrollViewDelegate代理
//点击手势监听
- (void) tapImageViewTappedWithObject:(id)sender
{
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
}

//图片长按手势监听
- (void) longPressImageViewTappedWithObject:(id) sender
{
    ImgScrollView *tmpImgView = sender;
    saveImageView = (UIImageView *)[tmpImgView.subviews objectAtIndex:0];
    
    if (!saveImgSheet) {
        saveImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    }
    
    [saveImgSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - savePhotoAlbumDelegate
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    NSString *message;
    NSString *title;
    
    if (!error) {
        title = @"恭喜";
        message = @"成功保存到相册";
    } else {
        title = @"失败";
        message = [error description];
    }
    [self initPopView:title message:message];
}

#pragma mark - 初始化视图
- (void)initPopView:(NSString *)title message:(NSString *)message {
    
    ZBAlertView *alter = [[ZBAlertView alloc] initWithTitle:title contentText:message leftButtonTitle:@"" rightButtonTitle:@"确定" baseView:self];
    alter.doneBlock = ^()
    {
        NSLog(@"确定");
    };
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //保存到手机相册
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(saveImageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
}

@end
