//
//  CouponItemVC.h
//  ArtEast
//
//  Created by zyl on 16/12/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponItemVC : UIViewController

typedef void (^SelectCouponBlock) (NSDictionary *dic);

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSString *from; //跳转来源
@property (nonatomic,copy) SelectCouponBlock couponBlock; //付款

@end
