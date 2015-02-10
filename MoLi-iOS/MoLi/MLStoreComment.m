//
//  MLStoreComment.m
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreComment.h"

@implementation MLStoreComment

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_username = [attributes[@"username"] notNull];
		_dateString = [attributes[@"senddate"] notNull];
		_content = [attributes[@"content"] notNull];
		_star = [attributes[@"star"] notNull];
	}
	return self;
}

@end
