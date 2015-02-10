//
//  MLSellerInfo.m
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLSellerInfo.h"

@implementation MLSellerInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_name = [attributes[@"name"] notNull];
		_phone = [attributes[@"phone"] notNull];
		_address = [attributes[@"address"] notNull];
	}
	return self;
}

@end
