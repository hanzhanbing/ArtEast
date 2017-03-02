//
//  RegisterForgetPswVC.h
//  ArtEast
//
//  Created by yibao on 16/10/12.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef enum {
    StateRegister = 0, //注册
    StateForgetPsw, //忘记密码
    StateChangePsw, //修改密码
}RegisterState;

@interface RegisterForgetPswVC : BaseVC

@property (nonatomic,assign)RegisterState state;

@end
