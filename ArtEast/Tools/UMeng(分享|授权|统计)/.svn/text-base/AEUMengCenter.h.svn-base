//
//  AEUMengCenter.h
//  ArtEast
//
//  Created by yibao on 16/9/29.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  分享、授权登录、统计
 *
 */

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSInteger , ShareType) {
    ShareText = 0, //纯文本分享
    ShareUrl, //网页分享
    ShareImage, //图片分享
    ShareMusic, //音乐分享
    ShareVideo, //视频分享
};

typedef NS_ENUM(NSInteger , LoginResult) {
    ResultFail = 0, //调用失败
    ResultLogin, //直接登录
    ResultBinding, //绑定手机号
};

#define kShareFinishedNotification @"kShareFinishedNotification"

typedef void(^ThirdLoginResult)(LoginResult result, NSString *errorString);

@interface AEUMengCenter : NSObject

//注册友盟(分享|授权|统计)
+ (void)registerUMeng;

//授权登录
+ (void)thirdLoginWithPlatform:(UMSocialPlatformType)platformType withBaseController:(UIViewController *)bController result:(ThirdLoginResult)loginResult;

//分享
+ (void)shareWithData:(NSMutableDictionary *)dic andType:(ShareType)shareType toPlatform:(UMSocialPlatformType)platformType withBaseController:(UIViewController *)bController;

@end
