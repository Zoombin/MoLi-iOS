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

@interface MLOrderDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MLOrderStoreCellDelegate, MLOrderAddressCellDelegate>

@property (nonatomic, strong) MLOrder *order;
@end
