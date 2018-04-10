/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseMessageViewController.h"

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"


@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic,retain) BaseNavBar *navBar;
@property (nonatomic,retain) UINavigationItem *navItem;

@property (nonatomic,assign) BOOL isPresent;

@end
