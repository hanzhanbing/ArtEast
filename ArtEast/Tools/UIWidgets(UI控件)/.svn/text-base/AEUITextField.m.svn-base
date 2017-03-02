//
//  AEUITextField.m
//  ArtEast
//
//  Created by yibao on 16/10/17.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEUITextField.h"

@interface AEUITextField ()<UITextFieldDelegate>

@end

@implementation AEUITextField

-(void)setCurrentShowDate:(NSDate *)currentShowDate{
    
    _currentShowDate = currentShowDate;
    self.inputDatePickerView.date = _currentShowDate;
    
}

- (void)createDatePicker:(int)status
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString*dateStartStr=[NSString stringWithFormat:@" 1900 1 1"];
    NSString*dateEndStr=[NSString stringWithFormat:@" 2100 1 1"];
    
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/zh_Hans_CN"]];
    
    _minDate =[dateFormat dateFromString:dateStartStr];
    _maxDate =[dateFormat dateFromString:dateEndStr];
    
    self.inputDatePickerView = [[UIDatePicker alloc] init];
    self.inputDatePickerView.datePickerMode = UIDatePickerModeDate;
    //    self.inputDatePickerView.minimumDate = _minDate;
    //    self.inputDatePickerView.maximumDate = _maxDate;
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.year = 1966;
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if (status == 0) {
        self.inputDatePickerView.maximumDate = [NSDate date];//最大日期
    } else {
        self.inputDatePickerView.minimumDate = [NSDate date];//最小日期
    }
    
    self.inputDatePickerView.timeZone = [NSTimeZone systemTimeZone];
    [self.inputDatePickerView setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    self.inputView = self.inputDatePickerView;
    
    self.placeholder = @"请选择";
}

- (void)createTimePicker
{
    self.inputDatePickerView = [[UIDatePicker alloc] init];
    self.inputDatePickerView.datePickerMode = UIDatePickerModeCountDownTimer;
    self.inputDatePickerView.timeZone = [NSTimeZone systemTimeZone];
    [self.inputDatePickerView setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    self.inputView = self.inputDatePickerView;
    self.placeholder = @"请选择";
}

- (void)createDicPicker
{
    self.inputPickerView = [[UIPickerView alloc] init];
    self.inputPickerView.delegate = self;
    self.inputPickerView.dataSource = self;
    self.inputView = self.inputPickerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textFieldToolbar = [[AEUIToolbar alloc]init];
        self.textFieldToolbar.delegate = self;
        self.inputAccessoryView = self.textFieldToolbar;
        self.textColor = [[UIColor alloc]initWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
        self.borderStyle = UITextBorderStyleNone;
        self.returnKeyType = UIReturnKeyDone;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeNever;
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor= [UIColor whiteColor];
        
    }
    return self;
}

- (id)initDatePickerWithframe:(CGRect)_frame haveLimit:(int)status
{
    self  = [self initWithFrame:_frame];
    if (self) {
        [self createDatePicker:status];
    }
    return self;
}

- (id)initTimePickerWithframe:(CGRect)_frame
{
    self  = [self initWithFrame:_frame];
    if (self) {
        [self createTimePicker];
    }
    return self;
}

- (id)initDicPickerWithframe:(CGRect)_frame data:(NSArray *)_data
{
    self = [self initWithFrame:_frame];
    if (self) {
        self.dataArr = _data;
        
        [self createDicPicker];
    }
    return self;
}

#pragma mark -UIDatePickerView
- (void)setDateInfo:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date = sender.date;
    self.text = [dateFormatter stringFromDate:self.date];
}

- (void)setTimeInfo:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.date = sender.date;
    self.text = [dateFormatter stringFromDate:self.date];
}
#pragma mark -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArr.count;
}
#pragma mark -UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArr objectAtIndex:row];
}

#pragma mark -AEUIToolbarDelegate
- (void)hiddenKeyboardAndEnsure
{
    [self resignFirstResponder];
    if ([self.inputView isKindOfClass:[UIDatePicker class] ] ) {
        if (self.inputDatePickerView.datePickerMode == UIDatePickerModeDate) {
            [self setDateInfo:self.inputDatePickerView];
        }
        else if (self.inputDatePickerView.datePickerMode == UIDatePickerModeCountDownTimer)
            [self setTimeInfo:self.inputDatePickerView];
    }
    else if (self.inputPickerView && _outerDelegate && [_outerDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [_outerDelegate pickerView:self.inputPickerView didSelectRow:[self.inputPickerView selectedRowInComponent:0] inComponent:0];
    }
}

- (void)hiddenKeyboardAndCancel
{
    [self resignFirstResponder];
}

- (void)dealloc
{
    self.outerDelegate = nil;
    self.delegate = nil;
}

@end
