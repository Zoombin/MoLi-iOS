//
//  MLGoodsIntroduceElement.m
//  MoLi
//
//  Created by zhangbin on 1/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsIntroduceElement.h"

@implementation MLGoodsIntroduceElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_name = [attributes[@"name"] notNull];
		_value = [attributes[@"value"] notNull];
	}
	return self;
}

@end
