//
//  UserInfo.h
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  用户Modle
 *
 */

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,assign) int sex; //0女1男
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *red_packets; //红包金额

+ (UserInfo *)share;

- (void)getUserInfo;

- (void)setUserInfo:(NSDictionary *)userDic;

@end
