//
//  AppDelegate+Push.m
//  ArtEast
//
//  Created by yibao on 16/9/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AppDelegate+Push.h"
#import <JPUSHService.h>
#import "GoodsModel.h"
#import "GoodsDetailVC.h"
#import "BaseWebVC.h"
#import "ChatViewController.h"

@implementation AppDelegate (Push)

-(void)registerPush:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    //iOS8以上 注册APNS【环信】
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    //可以添加自定义categories【激光推送】
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    NSString *pushAppKey=@"05df486f2d94eb04d60b57f5";
    NSString *pushChanne=@"iOS";
    
#ifdef DEBUG
    // 开发环境
    [JPUSHService setupWithOption:launchOptions appKey:pushAppKey channel:pushChanne apsForProduction:NO];
#else
    // 生产环境
    [JPUSHService setupWithOption:launchOptions appKey:pushAppKey channel:pushChanne apsForProduction:YES];
#endif

    [JPUSHService setLogOFF]; //关闭日志
}
#pragma mark 极光推送

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

/*
 * 有些手机只走这个通道
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [self didRecevieNotification:userInfo andState:application.applicationState];
}

/*
 * 正常通道
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self didRecevieNotification:userInfo andState:application.applicationState];
}

//处理收到的提醒
-(void)didRecevieNotification:(NSDictionary *)receiveNotifi andState:(UIApplicationState)state
{
    DLog(@"后台推送消息：%@",receiveNotifi);
    
    //在这里做消息处理...
    NSString *type=receiveNotifi[@"type"];
    NSString *value=receiveNotifi[@"value"];
    NSDictionary *apsDic=receiveNotifi[@"aps"];
    
    NSString *message=apsDic[@"alert"];
    
    if ([receiveNotifi isKindOfClass:[NSDictionary class]] && [receiveNotifi objectForKey:@"m"]) { //环信推送的信息
        type = @"Hyphenate";
        value = @"";
    }
    
    if (state == UIApplicationStateActive) { //前台运行
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您有一条新的推送消息" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpAction:type andValue:value];
        }])];
        [self.window.rootViewController presentViewController:alertController animated:true completion:nil];
    } else { //后台运行或者程序没启动
        [self jumpAction:type andValue:value];
    }
}

//点击通知页面跳转处理
- (void)jumpAction:(NSString *)type andValue:value {
    if ([type isEqualToString:@"content"]) { //内容详情
        [BaseWebVC showWithContro:self.window.rootViewController withUrlStr:[NSString stringWithFormat:@"%@/web/content/contentDetails.html?article_id=%@",WebUrl,value] withTitle:@"" isPresent:YES withShareContent:@""];
    }
    
    if ([type isEqualToString:@"goods"]) { //商品详情
        GoodsModel *goodsModel = [[GoodsModel alloc] init];
        goodsModel.icon = @"";
        goodsModel.ID = value;
        GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
        goodsDetailVC.goodsModel = goodsModel;
        goodsDetailVC.hideAnimation = YES;
        goodsDetailVC.isPresent = YES;
        [self.window.rootViewController presentViewController:goodsDetailVC animated:YES completion:nil];
    }
    
    if ([type isEqualToString:@"version"]) { //版本更新
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
        }
    }
    
    if ([type isEqualToString:@"activity"]) { //活动页
        [BaseWebVC showWithContro:self.window.rootViewController withUrlStr:[NSString stringWithFormat:@"%@%@",WebUrl,value] withTitle:@"" isPresent:YES withShareContent:@""];
    }
    
    if ([type isEqualToString:@"Hyphenate"]) { //环信
        if ([[EMClient sharedClient] isLoggedIn]) { //环信是否登录
            ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
            chatVC.isPresent = YES;
            [self.window.rootViewController presentViewController:chatVC animated:YES completion:nil];
        } else {
            [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
                    chatVC.isPresent = YES;
                    [self.window.rootViewController presentViewController:chatVC animated:YES completion:nil];
                }
            }];
        }
    }
}

@end
