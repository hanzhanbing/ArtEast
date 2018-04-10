//
//  AppDelegate.m
//  ArtEast
//
//  Created by yibao on 16/9/19.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "AppDelegate+Push.h"
#import "BaseNC.h"
#import "GuideVC.h"
#import "GuideBookVC.h"
#import "GoodsClassifyVC.h"
#import "LoveLifeVC.h"
#import "FineGoodsVC.h"
#import "FindVC.h"
#import "ShoppingCartVC.h"
#import "MineVC.h"
#import "LoginVC.h"
#import "UserInfo.h"
#import "AEFilePath.h"
#import "LauncherVC.h"

#import "NetworkUtil.h"
#import "AEUMengCenter.h"
#import "OrderVC.h"

#import "AEUpdateView.h"
#import <IQKeyboardManager.h>

//#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<WXApiDelegate>
{
    UITabBarController *myTabBarController;
    NSInteger selectIndex;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //环信注册
    EMOptions *options = [EMOptions optionsWithAppkey:@"1140170116115158#blesslife"];
#ifdef DEBUG
    // 开发环境
    options.apnsCertName = @"YouShengHuoDevPush";
#else
    // 生产环境
    options.apnsCertName = @"YouShengHuoDisPush";
#endif
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //环信登录
    [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"环信登录成功");
        }
    }];

    //键盘事件处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Utils isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppSecret"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"ea1af2ad4527edb95ad492943b986d6d426d99381953f10465a0ce6504b62a3e" forKey:@"AppSecret"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/api" forKey:@"ProductUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/" forKey:@"WebUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.6/" forKey:@"PictureUrl"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PageColor;
    
    [[UserInfo share] getUserInfo];
    [AEFilePath createDirPath];
    [[NetworkUtil sharedInstance] listening]; //监测网络
    [AEUMengCenter registerUMeng]; //注册友盟
    [self registerPush:application options:launchOptions]; //注册激光推送
    
    NSString *WecahtAppKey=@"wx8f86c08f17287606";
    NSString *WechatDescription=@"微信注册";
    [WXApi registerApp:WecahtAppKey withDescription:WechatDescription];
    
    //将launcherVC作为根视图控制器
    LauncherVC *launcherVC = [[LauncherVC alloc] init];
    self.window.rootViewController = launcherVC;
    
    launcherVC.doneBlock = ^(){
        //判断是否首次进入应用
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLG"])
        {
//            GuideVC *guideVC = [[GuideVC alloc] init];
            GuideBookVC *guideVC = [[GuideBookVC alloc] init];
            self.window.rootViewController = guideVC;
            
            //使用block获取点击图片事件
            [guideVC setButtonBlock:^(){
                NSLog(@"点击“进入”进入应用");
                //进入应用主界面
                self.window.rootViewController =[self setTabBarController] ;
            }];
        } else {
            self.window.rootViewController =[self setTabBarController] ;
        }
    };
    
//    NSError *setCategoryErr = nil;
//    NSError *activationErr  = nil;
//    [[AVAudioSession sharedInstance]
//     setCategory: AVAudioSessionCategoryPlayback
//     error: &setCategoryErr];
//    [[AVAudioSession sharedInstance]
//     setActive: YES
//     error: &activationErr];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 时尚主页
- (UITabBarController *)setTabBarController {
    
    //步骤1：初始化视图控制器
    FineGoodsVC *fineGoodsVC = [[FineGoodsVC alloc] init]; //要好物
    LoveLifeVC *loveLifeVC = [[LoveLifeVC alloc] init]; //爱生活
    //FindVC *findVC = [[FindVC alloc] init]; //发现
    GoodsClassifyVC *classifyVC = [[GoodsClassifyVC alloc] init]; //分类
    ShoppingCartVC *cartVC = [[ShoppingCartVC alloc] init]; //购物车
    MineVC *mineVC = [[MineVC alloc] init]; //我的
    
    //步骤2：将视图控制器绑定到导航控制器上
    BaseNC *nav1C = [[BaseNC alloc] initWithRootViewController:fineGoodsVC];
    BaseNC *nav2C = [[BaseNC alloc] initWithRootViewController:loveLifeVC];
    BaseNC *nav3C = [[BaseNC alloc] initWithRootViewController:classifyVC];
    BaseNC *nav4C = [[BaseNC alloc] initWithRootViewController:cartVC];
    BaseNC *nav5C = [[BaseNC alloc] initWithRootViewController:mineVC];
    
    //步骤3：将导航控制器绑定到TabBar控制器上
    myTabBarController = [[UITabBarController alloc] init];
    myTabBarController.delegate = self;
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kTabBarH)];
    barBgView.backgroundColor = [UIColor blackColor];
    [myTabBarController.tabBar insertSubview:barBgView atIndex:0];
    myTabBarController.tabBar.opaque = YES;
    
    myTabBarController.viewControllers = @[nav1C,nav2C,nav3C,nav4C,nav5C]; //需要先绑定viewControllers数据源
    myTabBarController.selectedIndex = 0; //默认选中第几个图标（此步操作在绑定viewControllers数据源之后）
    
    //初始化TabBar数据源
    NSArray *titles = @[@"首页",@"好物",@"分类",@"购物车",@"我的"];
    NSArray *images = @[@"UnTabbarLoveLife",@"UnTabbarFineGoods",@"UnTabbarFind",@"UnTabbarCart",@"UnTabbarMine"];
    NSArray *selectedImages = @[@"TabbarLoveLife",@"TabbarFineGoods",@"TabbarFind",@"TabbarCart",@"TabbarMine"];
    
    //绑定TabBar数据源
    for (int i = 0; i<myTabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = (UITabBarItem *)myTabBarController.tabBar.items[i];
        item.title = titles[i];
        item.image = [[UIImage imageNamed:[images objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[selectedImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }
    
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:LightYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateNormal];
    
    return myTabBarController;
}

#pragma mark - 分享、支付功能

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    return [self applicationOpenURL:url];
}

- (BOOL)applicationOpenURL:(NSURL *)url {
    
    //支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSInteger status=[resultDic[@"resultStatus"] integerValue];
            
            switch (status) {
                case 9000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
                    break;
                    
                case 8000:
                    [Utils showToast:@"订单正在处理中"];
                    break;
                    
                case 4000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFail" object:nil];
                    break;
                    
                case 6001:
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancel" object:nil];
                    break;
                    
                case 6002:
                    [Utils showToast:@"网络连接出错"];
                    break;
                    
                default:
                    break;
            }
        }];
        return YES;
    }
    
    //微信支付回调
    if([[url absoluteString] rangeOfString:@"wx8f86c08f17287606://pay"].location == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    //友盟分享、授权回调
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp *)resp {
    //微信支付信息
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp *)resp;
        
        NSLog(@"微信支付成功回调：%d",payResp.errCode);
        
        switch (payResp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
                break;
            case -1:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFail" object:nil];
                break;
            case -2:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancel" object:nil];
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //这里我判断的是当前点击的tabBarItem的标题
    NSString *tabBarTitle = viewController.tabBarItem.title;
    if ([tabBarTitle isEqualToString:@"我的"]) {
        //如果用户ID存在的话，说明已登陆
        if ([Utils isUserLogin]) {
            return YES;
        } else {
            //跳到登录页面
            LoginVC *loginVC = [[LoginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [((UINavigationController *)tabBarController.selectedViewController) pushViewController:loginVC animated:YES];
            return NO;
        }
    }
    if ([tabBarTitle isEqualToString:@"专栏"]) {
        tabBarController.selectedIndex = 0;
        return YES;
    }
    if ([tabBarTitle isEqualToString:@"分类"]) {
        tabBarController.selectedIndex = 2;
        return YES;
    }
    else {
        return YES;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (selectIndex!=tabBarController.selectedIndex) {
        //[self animationWithIndex:tabBarController.selectedIndex];
    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in myTabBarController.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.15;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    selectIndex = index;
}

#pragma mark - 禁用第三方键盘

//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
//{
//    return NO;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    //环信退出登录
    EMError *err = [[EMClient sharedClient] logout:NO];
    if (!err) {
        
    }
    
//    //为了让程序进入后台仍能运行定时器，参考链接：http://blog.csdn.net/su_tianbiao/article/details/49748789
//    UIApplication *app = [UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid) {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid) {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    });
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    //环信登录
    [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"环信登录成功");
        }
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}


@end
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
