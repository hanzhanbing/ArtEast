//
//  AEPickerView.h
//  ArtEast
//
//  Created by zyl on 16/12/24.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"

typedef void(^doneAction)(ProvinceModel *provinceModel);

@interface AEPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    ProvinceModel *getData;
    CGRect myFrame;
    UIPickerView *picker;
    NSMutableArray *dataArr;
}

@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic, copy) doneAction doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,retain) UIView *baseView;

/**
 *  初始化函数
 *
 *  @param frame 视图的位置
 *  @param data  数组
 *  @param bView self.view
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
      andDataSource:(NSArray *)data
           baseView:(UIView *)bView;

/**
 *  显示视图
 */
-(void)show;

@end
