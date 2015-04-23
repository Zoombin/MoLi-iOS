//
//  MLPaySuccessViewController.h
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPayment.h"
#import "ZBPaymentManager.h"

extern NSInteger const kVoucherPayType;

/// 支付结果页面.
@interface MLPayResultViewController : UIViewController

@property (nonatomic, strong) MLPayment *payment;
@property (nonatomic, assign) ZBPaymentType paymentType;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) BOOL payForBecomingVIP;

@end
