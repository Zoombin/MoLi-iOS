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
		_orderID = [attributes[@"orderno"] notNull];
		_orderIDs = [attributes[@"ordernos"] notNull];
		_payNO = [attributes[@"payno"] notNull];
		_totalPrice = [attributes[@"totalprice"] notNull];
		_payAmount = [attributes[@"payamount"] notNull];
		_payVoucher = [attributes[@"payvoucher"] notNull];
		_paySubject = [attributes[@"paysubject"] notNull];
		_payBody = [attributes[@"payBody"] notNull];
		_VIP = [attributes[@"vipmember"] notNull];
	}
	return self;
}

@end
