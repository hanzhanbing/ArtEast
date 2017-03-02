//
//  WKDelegateController.h
//  ArtEast
//
//  Created by yibao on 16/10/25.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDelegateController : UIViewController <WKScriptMessageHandler>

@property (weak, nonatomic) id<WKDelegate> delegate;

@end
