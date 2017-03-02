//
//  AEAlertView.h
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , AShowAnimationStyle) {
    ASAnimationDefault    = 0,
    ASAnimationLeftShake  ,
    ASAnimationTopShake   ,
    ASAnimationNO         ,
};

typedef void(^AlertClickIndexBlock)(NSInteger clickIndex);


@interface AEAlertView : UIView

@property (nonatomic,copy)AlertClickIndexBlock clickBlock;

@property (nonatomic,assign)AShowAnimationStyle animationStyle;

/**
 *  初始化alert方法（根据内容自适应大小，目前只支持1个按钮或2个按钮）
 *
 *  @param title         标题
 *  @param message       内容（根据内容自适应大小）
 *  @param cancelTitle   取消按钮
 *  @param otherBtnTitle 其他按钮
 *  @param block         点击事件block
 *
 *  @return 返回alert对象
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(AlertClickIndexBlock)block;

/**
 *  showAlertView
 */
-(void)showAlertView;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;

@end
