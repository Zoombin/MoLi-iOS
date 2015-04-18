//
//  MLFavoritesGoodsTableViewCell.h
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 我收藏的商品cell.
@interface MLFavoritesGoodsTableViewCell : UITableViewCell

- (void)updateValue:(MLGoods *)goods;

@end
