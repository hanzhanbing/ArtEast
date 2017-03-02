//
//  AEInfo.m
//  ArtEast
//
//  Created by yibao on 16/10/18.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEInfo.h"

@implementation AEInfo

MJExtensionLogAllProperties

-(id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSString class])
    {
        if ([oldValue isKindOfClass:[NSNull class]])
        {
            return @"";
        }
    }
    else if ([oldValue isKindOfClass:[NSNull class]])
    {
        return [[property.type.typeClass alloc] init];
    }
    return oldValue;
}

@end
