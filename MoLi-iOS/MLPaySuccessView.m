//
//  MLPaySuccessView.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPaySuccessView.h"

@implementation MLPaySuccessView


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIColor *colors = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = colors.CGColor;
        CGRect rect = CGRectMake(10, 20, 20, 20);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        //        [imageview setBackgroundColor:[UIColor redColor]];
        [imageview setImage:[UIImage imageNamed:@"paysuccess"]];
        [self addSubview:imageview];
        
        UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 20, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        orderStateLabel.text = @"订单支付成功！我们将尽快为您发货！";
        [orderStateLabel setTextColor:[UIColor colorWithRed:17/255.0 green:137/255.0 blue:1/255.0 alpha:1]];
        [orderStateLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:orderStateLabel];
        
        UIImageView *imageLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(orderStateLabel.frame)+10, CGRectGetWidth(frame)-20, 1)];
                [imageLine1 setBackgroundColor:colors];
//        [imageLine1 setImage:[UIImage imageNamed:@"Separator"]];
        [self addSubview:imageLine1];
        NSArray *ilabeText = @[@"订单编号:",@"已付金额:",@"支付方式:"];
        //        NSArray *labesSix = [NSArray arrayWithObjects:[UILabel alloc],] nil];
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
                [imageline2 setBackgroundColor:colors];
//        [imageline2 setImage:[UIImage imageNamed:@"Separator"]];
        
        [self addSubview:imageline2];
        
        UIButton *goshopBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-80, CGRectGetMaxY(imageline2.frame)+20, 80, 35)];
        goshopBtn.tag = 10000;
        [goshopBtn setTitle:@"继续购物" forState:UIControlStateNormal];
        [goshopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [goshopBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        goshopBtn.layer.borderWidth = 1;
        goshopBtn.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        goshopBtn.layer.cornerRadius = 5;
        [goshopBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goshopBtn];
        
        UIButton *myOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goshopBtn.frame)+10, CGRectGetMaxY(imageline2.frame)+20, 80, 35)];
        myOrderBtn.tag = 10001;
        [myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
        [myOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [myOrderBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:55/255.0 blue:28/255.0 alpha:1]];
        myOrderBtn.layer.cornerRadius = 5;
        [myOrderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:myOrderBtn];
        
        
    }
    return self;
}


-(void)btnClick:(UIButton*)btn{
    if (btn.tag == 10000) {
        if ([self.delegate respondsToSelector:@selector(goShoppingbtnClick)]) {
            [self.delegate goShoppingbtnClick];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(myOrderbtnClick)]) {
            [self.delegate myOrderbtnClick];
        }
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
