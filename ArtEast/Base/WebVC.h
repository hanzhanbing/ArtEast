//
//  WebVC.h
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  网页展示通用页面
 *
 */

#import "BaseVC.h"

@interface WebVC : BaseVC<UIWebViewDelegate>

@property(nonatomic, strong)NSString *navTitle;
@property(nonatomic, strong)UIWebView *webView;

/**
 *  加载本地文件(html/txt)
 *
 *  @param filePath 程序文件夹下文件路径
 */
- (void)loadLocalFile:(NSString *)filePath;

/**
 *  通过网络加载内容
 *
 *  @param urlStr url字符串
 */
- (void)loadFromURLStr:(NSString *)urlStr;

@end
