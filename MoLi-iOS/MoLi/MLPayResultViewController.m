//
//  MLPaySuccessViewController.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPayResultViewController.h"
#import "MLPaySuccessView.h"
#import "MLPayFailView.h"
#define DEF_IOS7LATTER [[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0

@interface MLPayResultViewController ()<paySuccessDelegate, payFailDelegate>

@end

@implementation MLPayResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setLeftBarButtonItemAsBackArrowButton];
    CGRect rect = self.view.frame;
    rect.size.height = 175;
    if (DEF_IOS7LATTER) {
        rect.origin.y = 84;
    }
	if (_success) {
		self.title = @"支付成功";
		MLPaySuccessView *payView = [[MLPaySuccessView alloc] initWithFrame:rect];
		payView.delegate = self;
		payView.orderNumber.text = [NSString stringWithFormat:@"%@", _payment.ID];
		payView.payMoney.text = [NSString stringWithFormat:@"%@", _payment.payAmount];
		if (_paymentType == ZBPaymentTypeAlipay) {
			payView.payType.text = @"支付宝";
		} else if (_paymentType == ZBPaymentTypeWeixin) {
			payView.payType.text = @"微信";
		}
		[self.view addSubview:payView];
	} else {
		self.title = @"支付失败";
		MLPayFailView *payView = [[MLPayFailView alloc] initWithFrame:rect];
		payView.delegate = self;
		[self.view addSubview:payView];
	}
}

//继续购物
- (void)goShoppingbtnClick {
    NSLog(@"点击了继续购物按钮");
}

//我的订单
- (void)myOrderbtnClick {
   NSLog(@"点击了我的订单按钮");
}


//重新支付
- (void)goingPaybtnClick {
	NSLog(@"点击了重新支付按钮");
}

//随便逛逛
- (void)lookingAroundbtnClick {
	NSLog(@"点击了随便逛逛按钮");
}


@end
