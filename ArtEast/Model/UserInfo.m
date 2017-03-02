//
//  UserInfo.m
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_userInfo = nil;
static NSUserDefaults *_defaults = nil;

@implementation UserInfo

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
        _defaults = [NSUserDefaults standardUserDefaults];
    });
    return _userInfo;
}

- (void)getUserInfo {
    
    NSDictionary *userDic = [_defaults objectForKey:@"UserInfo"];
    if (userDic) {
        [self loadUserDic:userDic];
    }
}

- (void)setUserInfo:(NSDictionary *)userDic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDic forKey:@"UserInfo"];
    [defaults synchronize];
    
    [self loadUserDic:userDic];
}

- (void)loadUserDic:(NSDictionary *)userDic {
    self.userID = userDic[@"member_id"];
//    NSString *thirdLoginType = [_defaults objectForKey:@"ThirdLoginType"];
//    if (thirdLoginType.length>0) {
//        self.account = thirdLoginType;
//    } else {
        self.account = userDic[@"login_account"];
//    }
    if([userDic[@"avatar"] rangeOfString:@"http"].location !=NSNotFound) {
        self.avatar = userDic[@"avatar"];
    } else {
        self.avatar = [NSString stringWithFormat:@"%@%@",PictureUrl,userDic[@"avatar"]];
    }
    self.nick = userDic[@"nick"];
    self.sex = [userDic[@"sex"] intValue];
    self.phone = userDic[@"mobile"];
    if ([Utils isBlankString:userDic[@"red_packets"]]) {
        self.red_packets = @"0.00";
    } else {
        self.red_packets = userDic[@"red_packets"];
    }
    self.birthday = [NSString stringWithFormat:@"%@-%@-%@",userDic[@"b_year"],userDic[@"b_month"],userDic[@"b_day"]];
    if (![Utils isBlankString:self.nick]) {
        self.userName = self.nick;
    } else {
        self.userName = self.account;
    }
}

@end
