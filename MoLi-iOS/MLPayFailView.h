//
//  MLPayFailView.h
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MLPayFailDelegate <NSObject>

-(void)retryAfterPay;//重新支付
-(void)lookingAroundAfterPay;//随便逛逛

@end

@interface MLPayFailView : UIView

@property (nonatomic, weak) id <MLPayFailDelegate> delegate;
@property (nonatomic, strong) UILabel *orderStateLabel;

@end
