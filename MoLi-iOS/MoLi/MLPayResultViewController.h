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

@protocol MLPayResultViewControllerDelegate <NSObject>

- (void)repay;

@end

@interface MLPayResultViewController : UIViewController

@property (nonatomic, weak) id <MLPayResultViewControllerDelegate> delegate;
@property (nonatomic, strong) MLPayment *payment;
@property (nonatomic, assign) ZBPaymentType paymentType;
@property (nonatomic, assign) BOOL success;

@end
