//
//  MLCity.m
//  MoLi
//
//  Created by zhangbin on 12/11/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLCity.h"

@implementation MLCity

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"cityid"] notNull];
		if (!_ID) {//pick city
			_ID = [attributes[@"cid"] notNull];
		}
		_name = [attributes[@"name"] notNull];
		if ([attributes[@"areas"] notNull]) {
			_areas = [MLArea multiWithAttributesArray:attributes[@"areas"]];
		}
	}
	return self;
}

@end
