//
//  MLOrder.h
//  MoLi
//
//  Created by zhangbin on 12/27/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLStore.h"
#import "MLGoods.h"
#import "MLOrderOperator.h"

typedef NS_ENUM(NSUInteger, MLOrderStatus) {
	MLOrderStatusAll,
	MLOrderStatusForPay,
	MLOrderStatusForSend,
	MLOrderStatusForTake,
	MLOrderStatusForComment
};

/// 订单信息.
@interface MLOrder : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSNumber *totalPrice;
@property (nonatomic, strong) MLStore *store;
@property (nonatomic, strong) NSArray *multiGoods;
@property (nonatomic, strong) NSArray *operators;


+ (NSString *)identifierForStatus:(MLOrderStatus)status;

@end
