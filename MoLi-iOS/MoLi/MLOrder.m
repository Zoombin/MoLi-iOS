//
//  MLOrder.m
//  MoLi
//
//  Created by zhangbin on 12/27/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLOrder.h"

@implementation MLOrder

+ (NSString *)identifierForStatus:(MLOrderStatus)status {
	if (status == MLOrderStatusForPay) {
		return @"forpay";
	} else if (status == MLOrderStatusForSend) {
		return @"forsend";
	} else if (status == MLOrderStatusForTake) {
		return @"fortake";
	} else if (status == MLOrderStatusForComment) {
		return @"forcomment";
	}
	return @"";
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"orderno"] notNull];
		_totalPrice = [attributes[@"totalprice"] notNull];
		NSString *storeID = [attributes[@"storeid"] notNull];
		NSString *storeName = [attributes[@"storename"] notNull];
		if (storeID) {
			_store = [[MLStore alloc] init];
			_store.ID = storeID;
			_store.name = storeName;
		}
		
		if ([attributes[@"goods"] notNull]) {
			_multiGoods = [MLGoods multiWithAttributesArray:[attributes[@"goods"] notNull]];
		}
		
		if ([attributes[@"oplist"] notNull]) {
			_operators = [MLOrderOperator multiWithAttributesArray:[attributes[@"oplist"] notNull]];
		}
	}
	return self;
}

@end
