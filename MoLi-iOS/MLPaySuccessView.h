//
//  MLPaySuccessView.h
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol paySuccessDelegate <NSObject>

@optional

-(void)goShoppingbtnClick;//继续购物
-(void)myOrderbtnClick;//我的订单


@end

@interface MLPaySuccessView : UIView


@property(nonatomic, weak) id<paySuccessDelegate> delegate;
@property(nonatomic, strong)UILabel *orderNumber;//订单编号
@property(nonatomic, strong)UILabel *payMoney;//已付金额
@property(nonatomic, strong)UILabel *payType;//支付方式

@end
