//
//  AEUIToolbar.m
//  ArtEast
//
//  Created by yibao on 16/10/17.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEUIToolbar.h"

@implementation AEUIToolbar
@dynamic delegate;

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    if (self) {
        self.backgroundColor = PageColor;
        
        UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 74, 3, 74, 38)];
        [doneButton setTitleColor:kColorFromRGBHex(0x1283fe) forState:UIControlStateNormal];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [doneButton addTarget:self action:@selector(ensureWithhiddenKeyboardAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 3, 74, 38)];
        [cancelButton setTitleColor:kColorFromRGBHex(0x1283fe) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton addTarget:self action:@selector(cancelWithHiddenKeyboardAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)ensureWithhiddenKeyboardAction:(id)sender
{
    [self.delegate hiddenKeyboardAndEnsure];
}

- (void)cancelWithHiddenKeyboardAction:(id)sender
{
    [self.delegate hiddenKeyboardAndCancel];
}

@end
