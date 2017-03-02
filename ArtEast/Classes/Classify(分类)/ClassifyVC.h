//
//  ClassifyVC.h
//  ArtEast
//
//  Created by yibao on 16/10/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  分类
 *
 */

#import "BaseVC.h"
#import "AETypeInfo.h"

@interface ClassifyCell : UITableViewCell
{
    UIImageView *_imageView;
    UIView *_btnView;
}

@property (nonatomic, retain)AETypeInfo *typeInfo;

@end


@interface ClassifyVC : BaseVC

@end
