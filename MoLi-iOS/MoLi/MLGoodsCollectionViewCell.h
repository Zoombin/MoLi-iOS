//
//  MLGoodsCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

/// 商品的collectioncell.
@interface MLGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MLGoods *goods;

+ (CGSize)size;

@end
