//
//  MLAskForAfterSalesViewController.h
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAfterSalesGoods.h"
#import "MLAddress.h"

/// 申请售后.
@interface MLAskForAfterSalesViewController : UIViewController

@property (nonatomic, strong) MLAfterSalesGoods *afterSalesGoods;
@property (nonatomic, assign) MLAfterSalesType type;
@property (nonatomic, strong) MLAddress *address;

@end
