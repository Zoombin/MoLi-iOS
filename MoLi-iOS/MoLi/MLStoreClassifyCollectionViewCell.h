//
//  MLStoreClassifyCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/29/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLStoreClassify.h"

/// 商品分类的collectioncell.
@interface MLStoreClassifyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MLStoreClassify *storeClassify;

+ (CGSize)size;

@end
