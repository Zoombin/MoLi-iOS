//
//  MLSecurity.m
//  MoLi
//
//  Created by zhangbin on 11/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLSecurity.h"

@implementation MLSecurity

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_appID = [attributes[@"appid"] notNull];
		_appSecret = [attributes[@"appsecret"] notNull];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_appID = [aDecoder decodeObjectForKey:@"appid"];
		_appSecret = [aDecoder decodeObjectForKey:@"appsecret"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_appID forKey:@"appid"];
	[aCoder encodeObject:_appSecret forKey:@"appsecret"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<appID:%@, appSecret:%@>", _appID, _appSecret];
}

@end
