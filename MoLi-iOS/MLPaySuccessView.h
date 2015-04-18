//
//  MLPaySuccessView.h
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MLPaySuccessDelegate <NSObject>

-(void)goShoppingAfterPay;//继续购物
-(void)goOrdersAfterPay;//我的订单

@end

/// 支付成功的view.
@interface MLPaySuccessView : UIView

@property(nonatomic, weak) id <MLPaySuccessDelegate> delegate;
@property(nonatomic, strong)UILabel *orderNumber;//订单编号
@property(nonatomic, strong)UILabel *payMoney;//已付金额
@property(nonatomic, strong)UILabel *payType;//支付方式

@end
