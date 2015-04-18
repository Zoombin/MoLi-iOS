//
//  MLGoodsPropertyCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/19/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoodsProperty.h"

/// 商品展示的collectioncell.
@interface MLGoodsPropertyCollectionViewCell : UICollectionViewCell

+ (CGFloat)widthForText:(NSString *)text;
- (void)setGoodsProperty:(MLGoodsProperty *)goodsProperty atIndexPath:(NSIndexPath *)indexPath;

@end
