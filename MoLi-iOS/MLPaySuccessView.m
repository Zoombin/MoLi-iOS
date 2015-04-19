//
//  MLPaySuccessView.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPaySuccessView.h"

@interface MLPaySuccessView ()

@property (readwrite) UIButton *goShoppingButton;

@end

@implementation MLPaySuccessView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIColor *color = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = color.CGColor;
        CGRect rect = CGRectMake(10, 20, 20, 20);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        [imageview setImage:[UIImage imageNamed:@"paysuccess"]];
        [self addSubview:imageview];
        
		_orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 20, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        _orderStateLabel.text = @"订单支付成功！我们将尽快为您发货！";
		_orderStateLabel.adjustsFontSizeToFitWidth = YES;
        [_orderStateLabel setTextColor:[UIColor colorWithRed:17/255.0 green:137/255.0 blue:1/255.0 alpha:1]];
        [_orderStateLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:_orderStateLabel];
        
        UIImageView *imageLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_orderStateLabel.frame)+10, CGRectGetWidth(frame)-20, 1)];
                [imageLine1 setBackgroundColor:color];
        [self addSubview:imageLine1];
        NSArray *ilabeText = @[@"订单编号:",@"已付金额:",@"支付方式:"];
        for (int il=0; il<[ilabeText count]; il++) {
            UILabel *labels = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageLine1.frame)+30+il*30, 80, 20)];
            labels.text = ilabeText[il];
            [labels setFont:[UIFont systemFontOfSize:14]];
            [labels setBackgroundColor:[UIColor clearColor]];
            [labels setTextColor:[UIColor grayColor]];
            [self addSubview:labels];
        }
        
        _orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(imageLine1.frame)+30, CGRectGetWidth(frame)-100-10, 20)];
        [_orderNumber setBackgroundColor:[UIColor clearColor]];
        [_orderNumber setFont:[UIFont systemFontOfSize:14]];
        [_orderNumber setTextColor:[UIColor grayColor]];
        [self addSubview:_orderNumber];
        
        _payMoney = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_orderNumber.frame)+10, CGRectGetWidth(frame)-100-10, 20)];
        [_payMoney setBackgroundColor:[UIColor clearColor]];
        [_payMoney setFont:[UIFont systemFontOfSize:14]];
        [_payMoney setTextColor:[UIColor grayColor]];
        [self addSubview:_payMoney];
        
        _payType = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_payMoney.frame)+10, CGRectGetWidth(frame)-100-10, 20)];
        [_payType setBackgroundColor:[UIColor clearColor]];
        [_payType setFont:[UIFont systemFontOfSize:14]];
        [_payType setTextColor:[UIColor grayColor]];
        [self addSubview:_payType];
        
        UIImageView *imageline2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_payType.frame)+30, CGRectGetWidth(frame)-20, 1)];
		[imageline2 setBackgroundColor:color];
        [self addSubview:imageline2];
        
		_goShoppingButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-80, CGRectGetMaxY(imageline2.frame)+20, 80, 35)];
        [_goShoppingButton setTitle:@"继续购物" forState:UIControlStateNormal];
        [_goShoppingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_goShoppingButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        _goShoppingButton.layer.borderWidth = 1;
        _goShoppingButton.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        _goShoppingButton.layer.cornerRadius = 5;
        [_goShoppingButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goShoppingButton];
        
        UIButton *myOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goShoppingButton.frame)+10, CGRectGetMaxY(imageline2.frame)+20, 80, 35)];
        [myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
        [myOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [myOrderBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:55/255.0 blue:28/255.0 alpha:1]];
        myOrderBtn.layer.cornerRadius = 5;
        [myOrderBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:myOrderBtn];
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender {
	if (sender == _goShoppingButton) {
		if (_delegate) {
			[self.delegate goShoppingAfterPay];
		}
	} else {
		if (_delegate) {
			[self.delegate goOrdersAfterPay];
		}
	}
}

@end
