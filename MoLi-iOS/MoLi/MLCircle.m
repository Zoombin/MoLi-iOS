//
//  MLCircle.m
//  MoLi
//
//  Created by zhangbin on 1/28/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLCircle.h"

@implementation MLCircle

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"cid"] notNull];
		_name = [attributes[@"circlename"] notNull];
	}
	return self;
}

@end
