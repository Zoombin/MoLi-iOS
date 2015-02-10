//
//  MLOrderSummary.m
//  MoLi
//
//  Created by zhangbin on 1/31/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLOrderSummary.h"

@implementation MLOrderSummary

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_hasNew = [attributes[@"hasnew"] notNull];
		_number = [attributes[@"num"] notNull];
	}
	return self;
}

@end
