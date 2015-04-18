//
//  MLGoodsOrderTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

/// 商品订单的tableviewcell.
@interface MLGoodsOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) MLGoods *goods;

@end
