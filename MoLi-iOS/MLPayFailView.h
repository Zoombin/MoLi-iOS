//
//  MLPayFailView.h
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol payFailDelegate <NSObject>

@optional

-(void)goingPaybtnClick;//重新支付
-(void)lookingAroundbtnClick;//随便逛逛


@end

@interface MLPayFailView : UIView

@property(nonatomic, weak) id<payFailDelegate> delegate;
@property(nonatomic, strong)UILabel *errormsgLabel;//显示错误信息

@end
