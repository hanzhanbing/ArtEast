//
//  BackProtocol.h
//  ArtEast
//
//  Created by yibao on 2017/1/5.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackProtocol <NSObject>

-(void)viewBeBack:(NSIndexPath *)indexPath andFromFlag:(NSString *)flag andPraiseFlag:(BOOL)praiseFlag;

@end
