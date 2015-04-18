//
//  MLPaymentViewController.h
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPayment.h"

/// 魔力收银台.
@interface MLPaymentViewController : UIViewController

@property (nonatomic, strong) MLPayment *payment;
@property (nonatomic, assign) BOOL payForBecomingVIP;

@end
