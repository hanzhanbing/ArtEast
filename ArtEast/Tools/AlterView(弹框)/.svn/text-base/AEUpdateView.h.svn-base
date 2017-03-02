//
//  AEUpdateView.h
//  ArtEast
//
//  Created by yibao on 16/10/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEUpdateView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) dispatch_block_t doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,retain) UIImage *image;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,retain) NSArray *textArr;
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;

@property (nonatomic,assign)AShowAnimationStyle animationStyle;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;

/**
 *  构造方法
 *
 *  @param image      图片
 *  @param textArr    更新内容
 *  @param leftTitle  左按钮标题
 *  @param rigthTitle 右按钮标题
 *
 *  @return id
 */
- (id)initWithImage:(UIImage *)image
        versionText:(NSString *)version
        contentText:(NSArray *)textArr
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

@end
