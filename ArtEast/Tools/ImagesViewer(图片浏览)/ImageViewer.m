//
//  ImageViewer.m
//  ArtEast
//
//  Created by yibao on 16/10/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ImageViewer.h"

@implementation ImageViewer

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray<NSString *> *)data tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {

        bgScrollView = [[UIScrollView alloc]initWithFrame:frame];
        bgScrollView.pagingEnabled = YES;
        bgScrollView.delegate = self;
        [self addSubview:bgScrollView];

        lable = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 40)];
        lable.text = [NSString stringWithFormat:@"%ld/%lu",tag+1,(unsigned long)data.count];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self addSubview:lable];

        for (int i=0; i<data.count; i++) {
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            scrollView.tag = 1+i;
            scrollView.delegate = self;
            scrollView.maximumZoomScale=5.0;
            scrollView.minimumZoomScale=0.5;

            scrollView.showsHorizontalScrollIndicator=NO;
            scrollView.showsVerticalScrollIndicator=NO;
            UIImageView *imageView = [[UIImageView alloc] init];

            [imageView sd_setImageWithURL:[NSURL URLWithString:data[i]] placeholderImage:nil];
            [scrollView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:data[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    return ;
                }
                imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width/(image.size.width/image.size.height));
                imageView.center = CGPointMake(scrollView.bounds.size.width *0.5,scrollView.bounds.size.height*0.5);
            }];
            [bgScrollView addSubview:scrollView];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
            [scrollView addGestureRecognizer:tap];
            imageView.tag = 1+i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *atppp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleme:)];
            atppp.numberOfTapsRequired =2;

            [tap requireGestureRecognizerToFail:atppp];
            [scrollView  addGestureRecognizer:atppp];
        }

        if (tag<data.count) {
            bgScrollView.contentOffset=CGPointMake(frame.size.width*tag, 0);
        }

        bgScrollView.contentSize = CGSizeMake(frame.size.width*data.count, frame.size.height);
        bgScrollView.maximumZoomScale=2.5;
        bgScrollView.minimumZoomScale=0.5;
    }

    return self;
}

- (instancetype)initWithFrame1:(CGRect)frame andData:(NSArray<NSData *> *)data tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        bgScrollView = [[UIScrollView alloc]initWithFrame:frame];
        bgScrollView.delegate = self;
        [self addSubview:bgScrollView];
        bgScrollView.pagingEnabled = YES;
        bgScrollView.delegate = self;
        lable = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 40)];
        lable.text = [NSString stringWithFormat:@"%ld/%lu",tag+1,(unsigned long)data.count];
        lable.tag = 9999;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self addSubview:lable];

        for (int i=0; i<data.count; i++) {

            UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            sc.tag = 1+i;
            sc.delegate = self;
            sc.maximumZoomScale=5.0;
            sc.minimumZoomScale=0.5;

            sc.showsHorizontalScrollIndicator=NO;
            sc.showsVerticalScrollIndicator=NO;
          
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            imageView.image = [UIImage imageWithData:data[i]];
            [sc addSubview:imageView];

            [bgScrollView addSubview:sc];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
            [sc addGestureRecognizer:tap];
            imageView.tag = 1+i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *atppp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleme:)];
            atppp.numberOfTapsRequired =2 ;

            [tap requireGestureRecognizerToFail:atppp];
            [sc  addGestureRecognizer:atppp];
        }

        if (tag<data.count) {
            bgScrollView.contentOffset=CGPointMake(frame.size.width*tag, 0);
        }

        bgScrollView.contentSize = CGSizeMake(frame.size.width*data.count, frame.size.height);
        bgScrollView.maximumZoomScale=2.5;
        bgScrollView.minimumZoomScale=0.5;

        lable.text = [NSString stringWithFormat:@"%d/%d",(int)(bgScrollView.contentOffset.x/WIDTH+1),(int)(bgScrollView.contentSize.width/WIDTH)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andUrlArr:(NSArray *)urlArr tag:(NSInteger)tag {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        bgScrollView = [[UIScrollView alloc]initWithFrame:frame];
        bgScrollView.delegate = self;
        [self addSubview:bgScrollView];
        bgScrollView.pagingEnabled = YES;
        bgScrollView.delegate = self;
        lable = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 40)];
        lable.text = [NSString stringWithFormat:@"%ld/%lu",tag+1,(unsigned long)urlArr.count];
        lable.tag = 9999;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self addSubview:lable];
        
        for (int i=0; i<urlArr.count; i++) {
            
            UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            sc.tag = 1+i;
            sc.delegate = self;
            sc.maximumZoomScale=5.0;
            sc.minimumZoomScale=0.5;
            
            sc.showsHorizontalScrollIndicator=NO;
            sc.showsVerticalScrollIndicator=NO;
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:nil options:SDWebImageProgressiveDownload];
            [sc addSubview:imageView];
            
            [bgScrollView addSubview:sc];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
            [sc addGestureRecognizer:tap];
            imageView.tag = 1+i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *atppp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleme:)];
            atppp.numberOfTapsRequired =2 ;
            
            [tap requireGestureRecognizerToFail:atppp];
            [sc  addGestureRecognizer:atppp];
        }
        
        if (tag<urlArr.count) {
            bgScrollView.contentOffset=CGPointMake(frame.size.width*tag, 0);
        }
        
        bgScrollView.contentSize = CGSizeMake(frame.size.width*urlArr.count, frame.size.height);
        bgScrollView.maximumZoomScale=2.5;
        bgScrollView.minimumZoomScale=0.5;
        
        lable.text = [NSString stringWithFormat:@"%d/%d",(int)(bgScrollView.contentOffset.x/WIDTH+1),(int)(bgScrollView.contentSize.width/WIDTH)];
    }
    return self;
}

-(void)scaleme:(UITapGestureRecognizer *)t{
    if ([t.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *sc= (UIScrollView *)t.view;
        [UIView animateWithDuration:0.25 animations:^{

            sc.zoomScale = sc.zoomScale == 2.5?1.0:2.5;
        }];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *vv = [scrollView subviews][0];
    return vv;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    UIImageView *imm = scrollView.subviews[0];
    CGRect contentsFrame = imm.frame;

    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }

    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }

    imm.frame = contentsFrame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isEqual:bgScrollView]) {
        UILabel *ll = [self viewWithTag:9999];
        ll.text = [NSString stringWithFormat:@"%d/%d",(int)(scrollView.contentOffset.x/WIDTH+1),(int)(scrollView.contentSize.width/WIDTH)];
    }
}

- (void)centerScrollViewContents {

}

-(void)hideSelf:(UITapGestureRecognizer *)tap{
    self.hidden = YES;
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];

    /*
     if (hidden==YES) {

     POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
     scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
     scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
     scaleAnimation.springBounciness    = 10.f;
     [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];

     POPSpringAnimation *scaleAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
     scaleAnimation2.toValue             = @0;

     [self pop_addAnimation:scaleAnimation2 forKey:@"alp"];

     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [super setHidden:hidden];
     });

     }else{
     [super setHidden:hidden];
     POPSpringAnimation *scaleAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
     scaleAnimation2.toValue             = @1;

     [self pop_addAnimation:scaleAnimation2 forKey:@"alp"];

     POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
     scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
     scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
     scaleAnimation.springBounciness    = 10.f;
     [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
     }
     
     */
}

@end
