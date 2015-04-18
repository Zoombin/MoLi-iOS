//
//  MLCategoryTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 2/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoodsClassify.h"

/// 类别cell.
@interface MLCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) MLGoodsClassify *goodsClassify;

@end
