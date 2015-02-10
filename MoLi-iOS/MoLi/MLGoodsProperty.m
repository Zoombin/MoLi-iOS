//
//  MLGoodsProperty.m
//  MoLi
//
//  Created by zhangbin on 12/20/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsProperty.h"

@implementation MLGoodsProperty

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_name = [attributes[@"name"] notNull];
		_values = [attributes[@"list"] notNull];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<name:%@, values:%@>", _name, _values];
}

@end
