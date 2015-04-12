//
//  MLPaySuccessViewController.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPaySuccessViewController.h"
#import "MLPaySuccessView.h"

@interface MLPaySuccessViewController ()<paySuccessDelegate>

@end

@implementation MLPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    MLPaySuccessView *payView = [[MLPaySuccessView alloc] initWithFrame:self.view.bounds];
    payView.delegate = self;
    payView.orderNumber.text = @"2000000001028544";
    payView.payMoney.text = @"￥1003.60";
    payView.payType.text = @"支付宝";
    [self.view addSubview:payView];
}

//继续购物
-(void)goShoppingbtnClick {
    NSLog(@"点击了继续购物按钮");
}

//我的订单
-(void)myOrderbtnClick {
   NSLog(@"点击了我的订单按钮");

}

@end
