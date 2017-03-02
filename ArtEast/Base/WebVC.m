//
//  WebVC.m
//  ArtEast
//
//  Created by yibao on 16/10/14.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
}

- (void)setNavTitle:(NSString *)navTitle
{
    self.title = navTitle;
}

- (NSString *)navTitle
{
    return self.navTitle;
}

- (void)loadLocalFile:(NSString *)fileName
{
    //文件内容string
    NSString *file = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    NSString *fileString = [[NSString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:fileString baseURL:nil];
}

- (void)loadFromURLStr:(NSString *)urlStr
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

#pragma mark -WebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Utils showToast:error.localizedDescription];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
