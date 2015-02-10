//
//  MLProvince.m
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLProvince.h"

@implementation MLProvince

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"pid"] notNull];
		_name = [attributes[@"name"] notNull];
	}
	return self;
}

@end
