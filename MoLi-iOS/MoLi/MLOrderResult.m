//
//  MLOrderResult.m
//  MoLi
//
//  Created by zhangbin on 1/21/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLOrderResult.h"

@implementation MLOrderResult

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_multiNO = [attributes[@"ordernos"] notNull];
		_payAmount = [attributes[@"payamount"] notNull];
		_payNO = [attributes[@"payno"] notNull];
		_payVoucher = [attributes[@"payvoucher"] notNull];
		_VIP = [attributes[@"vipmember"] notNull];
	}
	return self;
}

@end
