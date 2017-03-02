//
//  WKDelegateController.m
//  ArtEast
//
//  Created by yibao on 16/10/25.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "WKDelegateController.h"

@interface WKDelegateController ()

@end

@implementation WKDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
