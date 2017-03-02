//
//  ZBAlertView.h
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBAlertView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) dispatch_block_t doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;
@property (nonatomic,retain) UIView *baseView;
@property (nonatomic,assign) BOOL flag; //YES:取消和确定2个按钮  NO:只有确定按钮

@property (nonatomic,assign)AShowAnimationStyle animationStyle;

/**
 *  构造方法
 *
 *  @param title      标题
 *  @param content    内容
 *  @param leftTitle  左按钮标题
 *  @param rigthTitle 右按钮标题
 *  @param bView      self.view
 *
 *  @return id
 */
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
           baseView:(UIView *)bView;

@end
