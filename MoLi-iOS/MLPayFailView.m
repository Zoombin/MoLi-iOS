//
//  MLPayFailView.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPayFailView.h"

@interface MLPayFailView ()

@property (readwrite) UIButton *goingPayBtn;

@end

@implementation MLPayFailView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        UIColor *colors = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = colors.CGColor;
        CGRect rect = CGRectMake(10, 20, 20, 20);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        [imageview setImage:[UIImage imageNamed:@"payfail"]];
        [self addSubview:imageview];
        
        UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 20, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        orderStateLabel.text = @"很抱歉！您的订单支付失败!";
        [orderStateLabel setTextColor:[UIColor colorWithRed:228/255.0 green:64/255.0 blue:38/255.0 alpha:1]];
        [orderStateLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:orderStateLabel];
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(orderStateLabel.frame), CGRectGetMaxY(orderStateLabel.frame)+10, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        [errorLabel setFont:[UIFont systemFontOfSize:13.0]];
        [errorLabel setTextColor:[UIColor lightGrayColor]];
		errorLabel.text = @"未知错误：请稍后检查交易记录确认交易结果！";
        [self addSubview:errorLabel];
        
        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(errorLabel.frame)+30, CGRectGetWidth(frame)-20, 1)];
        [imageLine setBackgroundColor:colors];
        [self addSubview:imageLine];
        
		_goingPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-80, CGRectGetMaxY(imageLine.frame) + 20, 80, 35)];
        [_goingPayBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        [_goingPayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_goingPayBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        _goingPayBtn.layer.borderWidth = 1;
        _goingPayBtn.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        _goingPayBtn.layer.cornerRadius = 5;
        [_goingPayBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goingPayBtn];
        
        UIButton *myOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goingPayBtn.frame)+10, CGRectGetMaxY(imageLine.frame)+20, 80, 35)];
        myOrderBtn.tag = 20001;
        [myOrderBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
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
    if (sender == _goingPayBtn) {
		if (_delegate) {
			[_delegate retryAfterPay];
		}
    } else {
		if (_delegate) {
			[_delegate lookingAroundAfterPay];
		}
	}
}


@end
