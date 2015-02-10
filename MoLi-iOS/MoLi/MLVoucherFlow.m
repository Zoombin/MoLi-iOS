//
//  MLVoucherFlow.m
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherFlow.h"

@implementation MLVoucherFlow

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_action = [attributes[@"action"] notNull];
		_amount = [attributes[@"amount"] notNull];
	}
	return self;
}

@end
