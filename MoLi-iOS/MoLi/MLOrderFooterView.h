//
//  MLOrderFooterView.h
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLOrderOperator.h"
#import "MLOrder.h"
#import "MLAfterSalesGoods.h"

@protocol MLOrderFooterViewDelegate <NSObject>

@optional
- (void)executeOrder:(MLOrder *)order withOperator:(MLOrderOperator *)orderOperator;
- (void)executeAfterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods withOperator:(MLOrderOperator *)orderOperator;

@end

/// 订单的footer.
@interface MLOrderFooterView : UIView

@property (nonatomic, weak) id <MLOrderFooterViewDelegate> delegate;
@property (nonatomic, strong) MLOrder *order;
@property (nonatomic, strong) MLAfterSalesGoods *afterSalesGoods;
@property (nonatomic)   BOOL bNoNeedCornerLine; 

+ (CGFloat)height;

@end
