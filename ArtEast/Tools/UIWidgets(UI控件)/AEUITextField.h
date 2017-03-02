//
//  AEUITextField.h
//  ArtEast
//
//  Created by yibao on 16/10/17.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEUIToolbar.h"

//简讯的代理
@protocol AEUITextFieldPickerViewDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

typedef void(^FinishBlock)(NSString *);

@interface AEUITextField : UITextField<UIPickerViewDataSource, UIPickerViewDelegate, AEUIToolbarDelegate,UITextFieldDelegate>

@property(nonatomic, strong)UIPickerView *inputPickerView;
@property(nonatomic, strong)UIDatePicker *inputDatePickerView;
@property(nonatomic, strong)NSDate *date;

@property(nonatomic, strong)NSDate *minDate;
@property(nonatomic, strong)NSDate *maxDate;

@property(nonatomic, strong)NSArray *dataArr;

@property(nonatomic, assign)id<AEUITextFieldPickerViewDelegate> outerDelegate;          //简讯用
@property(nonatomic, strong)AEUIToolbar *textFieldToolbar;

@property(nonatomic, strong)FinishBlock finishBlock;       //可多选的数组的block

@property(nonatomic, strong)NSDate *currentShowDate;

//status：0 当前日期之前  1 当前日期之后
- (id)initDatePickerWithframe:(CGRect)_frame haveLimit:(int)status;           //日期

- (id)initTimePickerWithframe:(CGRect)_frame;           //时间

- (id)initDicPickerWithframe:(CGRect)_frame data:(NSArray *)_data;      //简讯数组数据

@end
