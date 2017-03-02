//
//  BestProjectView.h
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  精选专题
 *
 */

#import <UIKit/UIKit.h>

@class AEImages;
typedef void (^ProjectBlock) (AEImages *images);

@interface BestProjectView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy) ProjectBlock projectBlock;

@property (nonatomic,strong) UICollectionView *projectCollectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
