//
//  BaseWebVC.h
//  ArtEast
//
//  Created by yibao on 16/10/17.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebVC : BaseVC

@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *webTitle;
@property (strong, nonatomic) NSString *shareContent;
@property (assign, nonatomic) BOOL isPresent;
@property (strong, nonatomic) NSMutableArray *imagesUrlArr;

/** 传入控制器、url、标题 H5获取参数*/
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent withShareContent:(NSString *)shareContent;

@end
