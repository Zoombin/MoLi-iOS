//
//  MLPayFailView.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPayFailView.h"

@implementation MLPayFailView


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        CGRect rect = CGRectMake(10, 20, 20, 20);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        //        [imageview setBackgroundColor:[UIColor redColor]];
        [imageview setImage:[UIImage imageNamed:@"Selected"]];
        [self addSubview:imageview];
        
        UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 20, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        orderStateLabel.text = @"很抱歉！您的订单支付失败!";
        [orderStateLabel setTextColor:[UIColor colorWithRed:228/255.0 green:64/255.0 blue:38/255.0 alpha:1]];
        [orderStateLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:orderStateLabel];
        
        _errormsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(orderStateLabel.frame), CGRectGetMaxY(orderStateLabel.frame)+10, CGRectGetWidth(frame)-CGRectGetMaxX(imageview.frame)-20, 20)];
        [_errormsgLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:_errormsgLabel];
    
        
        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_errormsgLabel.frame)+30, CGRectGetWidth(frame)-20, 1)];
        //        [imageLine1 setBackgroundColor:[UIColor grayColor]];
        [imageLine setImage:[UIImage imageNamed:@"Separator"]];
        [self addSubview:imageLine];
        
        UIButton *goingPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-80, CGRectGetMaxY(imageLine.frame)+20, 80, 35)];
        goingPayBtn.tag = 20000;
        [goingPayBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        [goingPayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [goingPayBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        goingPayBtn.layer.borderWidth = 1;
        goingPayBtn.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        goingPayBtn.layer.cornerRadius = 5;
        [goingPayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goingPayBtn];
        
        UIButton *myOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goingPayBtn.frame)+10, CGRectGetMaxY(imageLine.frame)+20, 80, 35)];
        myOrderBtn.tag = 20001;
        [myOrderBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
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
    if (btn.tag == 20000) {
        if ([self.delegate respondsToSelector:@selector(goingPaybtnClick)]) {
            [self.delegate goingPaybtnClick];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(lookingAroundbtnClick)]) {
            [self.delegate lookingAroundbtnClick];
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
