//
//  MLPayment.m
//  MoLi
//
//  Created by zhangbin on 4/12/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLPayment.h"

@implementation MLPayment

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"payno"] notNull];
		_orderID = [attributes[@"orderno"] notNull];
		_orderIDs = [attributes[@"ordernos"] notNull];
		_totalPrice = [attributes[@"totalprice"] notNull];
		_payAmount = [attributes[@"payamount"] notNull];
		_payVoucher = [attributes[@"payvoucher"] notNull];
		_paySubject = [attributes[@"paysubject"] notNull];
		_payBody = [attributes[@"payBody"] notNull];
		_VIP = [attributes[@"vipmember"] notNull];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ID:%@, orderID:%@, orderIDs:%@, paySubject:%@, payBody:%@>", _ID, _orderID, _orderIDs, _paySubject, _payBody];
}

@end
