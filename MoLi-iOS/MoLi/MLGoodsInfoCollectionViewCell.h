//
//  MLGoodsInfoCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

@protocol MLGoodsInfoCollectionViewCellDelegate <NSObject>

- (void)goods:(MLGoods *)goods farovite:(BOOL)favorite;

@end

@interface MLGoodsInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <MLGoodsInfoCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) MLGoods *goods;

@end
