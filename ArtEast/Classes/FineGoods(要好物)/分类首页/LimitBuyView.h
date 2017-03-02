//
//  LimitBuyView.h
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  限时购
 *
 */

#import <UIKit/UIKit.h>

typedef void (^BuyBlock)(NSString *webUrl);

@interface LimitBuyView : UICollectionReusableView

@property (nonatomic,copy) BuyBlock buyBlock; //跳转到限时抢购
@property (nonatomic,retain) NSMutableDictionary *limitDic;

@end
