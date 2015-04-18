//
//  MLOrderDetailViewController.h
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLOrder.h"
#import "MLOrderStoreCell.h"
#import "MLOrderAddressCell.h"
#import "MLOrderGoodsCell.h"

/// 订单详情.
@interface MLOrderDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MLOrderStoreCellDelegate, MLOrderAddressCellDelegate, MLOrderGoodsCellDelegate>

@property (nonatomic, strong) MLOrder *order;
@end
