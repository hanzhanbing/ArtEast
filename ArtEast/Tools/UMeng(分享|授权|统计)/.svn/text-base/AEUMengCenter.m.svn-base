//
//  AEUMengCenter.m
//  ArtEast
//
//  Created by yibao on 16/9/29.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEUMengCenter.h"
#import "UMMobClick/MobClick.h"
#import "AESCrypt.h"
#import "JPUSHService.h"

static AEUMengCenter *_UMengCenter;

@implementation AEUMengCenter

+ (AEUMengCenter *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _UMengCenter = [[AEUMengCenter alloc] init];
    });
    return _UMengCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)registerUMeng {
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b432afe0f55a9832001a0a"];
    
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8f86c08f17287606" appSecret:@"49d1ed691aa10465037793d68e711a9d" redirectURL:@"http://www.cydf.com"];
    
    //设置分享到QQ互联的appId和appKey
    //[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105698963"  appSecret:@"aPobzH1IIjyUxq44" redirectURL:@"http://www.cydf.com"];
    
    //设置新浪的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3069801369"  appSecret:@"4e6354a288b0a2db71181617c5b121eb" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    //初始化友盟统计
    UMConfigInstance.appKey = @"57e1e5b5e0f55a90740019d7";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //应用趋势分析(版本分布)
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //渠道分析(SDK没有该方法)
    //[MobClick startWithAppkey:@"xxxxxxxxxxxxxxx" reportPolicy:SEND_INTERVAL   channelId:@"Web"];
    
    //账号统计
    //当用户使用自有账号登录时，可以这样统计：
    //[MobClick profileSignInWithPUID:@"playerID"];
    //当用户使用第三方账号（如新浪微博）登录时，可以这样统计：
    //[MobClick profileSignInWithPUID:@"playerID" provider:@"WB"];
    
    //日志加密设置
    [MobClick setEncryptEnabled:YES]; //加密，默认为NO(不加密)
}

+ (void)thirdLoginWithPlatform:(UMSocialPlatformType)platformType withBaseController:(UIViewController *)bController result:(ThirdLoginResult)loginResult {
    
    [[UMSocialManager defaultManager] authWithPlatform:platformType currentViewController:bController completion:^(id result, NSError *error) {
        if (result) {
            UMSocialAuthResponse *authresponse = result;
            NSString *message1 = [NSString stringWithFormat:@"uid: %@\n accessToken: %@\n",authresponse.uid,authresponse.accessToken];
            DLog(@"第三方登录授权信息：%@",message1);
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:bController completion:^(id result, NSError *error) {
                if (result) {
                    UMSocialUserInfoResponse *userinfo =result;
                    NSString *message2 = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
                    DLog(@"第三方登录用户信息：%@",message2);
                    
                    NSString *provider_code = @"";
                    NSString *gender = @"";
                    if ([userinfo.gender isEqualToString:@"男"]) {
                        gender = @"1";
                    }
                    if ([userinfo.gender isEqualToString:@"女"]) {
                        gender = @"0";
                    }
                    if (platformType == UMSocialPlatformType_QQ) {
                        provider_code = @"QQ";
                    }
                    if (platformType == UMSocialPlatformType_WechatSession) {
                        provider_code = @"Wechat";
                    }
                    if (platformType == UMSocialPlatformType_Sina) {
                        provider_code = @"Sina";
                    }
                
                    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         provider_code, @"provider_code",
                                         authresponse.uid, @"openid",
                                         userinfo.name, @"nickname",
                                         @"", @"realname",
                                         userinfo.iconurl, @"avatar",
                                         gender.length>0?gender:@"1", @"gender",
                                         @"", @"email",
                                         nil];
                    
                    [[NetworkManager sharedManager] postJSON:URL_ThirdLogin parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                        
                        [JHHJView hideLoading]; //结束加载
                        
                        if (status == Request_Success) {
                            
                            if ([responseData isKindOfClass:[NSDictionary class]]|| [Utils isBlankString:responseData]) {
                                [[NSUserDefaults standardUserDefaults] setObject:userinfo.iconurl forKey:@"Avatar"];
                                [[NSUserDefaults standardUserDefaults] setObject:authresponse.uid forKey:@"OpenId"];
                                [[NSUserDefaults standardUserDefaults] setObject:userinfo.name forKey:@"NickName"];
                                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"RealName"];
                                loginResult(ResultBinding,nil);
                            } else {
                                if ([responseData isKindOfClass:[NSString class]]&&![Utils isBlankString:responseData]) {
                                    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
                                    [userDic setValue:responseData forKey:@"member_id"];
                                    [[UserInfo share] setUserInfo:userDic];
                                    loginResult(ResultLogin,nil);
                                } else {
                                    loginResult(ResultFail,nil);
                                }
                            }
                            
                        } else {
                           loginResult(ResultFail,[error localizedDescription]);
                        }
                    }];
                } else {
                    loginResult(ResultFail,[error localizedDescription]);
                }
            }];
        } else {
            loginResult(ResultFail,[error localizedDescription]);
        }
    }];
}

+ (void)shareWithData:(NSDictionary *)dic andType:(ShareType)shareType toPlatform:(UMSocialPlatformType)platformType withBaseController:(UIViewController *)bController {
    
    //取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:nil];
    
    NSString *title = dic[@"title"];
    NSString *url = dic[@"url"];
    NSString *text = dic[@"text"];
    NSString *imageUrl = dic[@"image"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    switch (shareType) {
        case ShareText:
            //创建纯文本对象
            messageObject.text = [NSString stringWithFormat:@"%@%@",text,url];
            break;
        case ShareUrl:
        {
            NSLog(@"tyjyukiul%@",url);
            //创建网页分享内容对象
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:imageUrl];
            [shareObject setWebpageUrl:url];
            messageObject.shareObject = shareObject;
        }
            break;
        case ShareImage:
        {
            //创建图片对象
            UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:text thumImage:imageUrl];
            [shareObject setShareImage:imageUrl];
            messageObject.shareObject = shareObject;
        }
            break;
        case ShareMusic:
        {
            //创建音乐对象
            UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:text thumImage:imageUrl];
            [shareObject setMusicUrl:@"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3"];
            messageObject.shareObject = shareObject;
        }
            break;
        case ShareVideo:
        {
            //创建视频对象
            UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:imageUrl];
            [shareObject setVideoUrl:@"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"];
            messageObject.shareObject = shareObject;
        }
            break;
            
        default:
            break;
    }
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:bController completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        } else {
            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            } else {
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
        DLog(@"%@",message);
        [Utils showToast:message];
    }];
}

@end
