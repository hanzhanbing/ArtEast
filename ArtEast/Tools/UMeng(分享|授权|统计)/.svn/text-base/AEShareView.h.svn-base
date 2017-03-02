//
//  AEShareView.h
//  ArtEast
//
//  Created by yibao on 16/9/23.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  分享视图
 *
 */

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "AEUMengCenter.h"

@interface AEShareView : UIView

@property (nonatomic,retain) UIViewController *baseController;
@property (nonatomic,retain) UIView *baseView;
@property (nonatomic,retain) NSMutableDictionary *paramDic;
@property (nonatomic,assign) ShareType shareType;

/**
 *  初始化函数
 *
 *  @param bController self
 *  @param bView self.view
 *  @param dic 分享参数
 *
 *  @return 对象实例
 */
- (id)initWithBaseController:(UIViewController *)bController andBaseView:(UIView *)bView andData:(NSMutableDictionary *)dic andType:(ShareType)type;

/**
 *  显示视图
 */
-(void)show;

@end
