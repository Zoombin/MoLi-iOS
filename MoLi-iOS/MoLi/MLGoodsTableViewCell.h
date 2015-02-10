//
//  MLGoodsTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

@interface MLGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) MLGoods *goods;
@property (nonatomic, assign) BOOL cartMode;

@end
