//
//  MLLogistic.m
//  MoLi
//
//  Created by zhangbin on 1/21/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLLogistic.h"

@implementation MLLogistic

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		NSString *imagepath = [attributes[@"logo"] notNull];
        _imagePath = [imagepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		_name = [attributes[@"name"] notNull];
		_shippingNO = [attributes[@"no"] notNull];
		_linkURLString = [attributes[@"link"] notNull];
        _msg = [attributes[@"msg"] notNull];
        _time = [attributes[@"time"] notNull];
	}
	return self;
}

@end
