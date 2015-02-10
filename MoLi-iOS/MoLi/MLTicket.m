//
//  MLTicket.m
//  MoLi
//
//  Created by zhangbin on 11/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLTicket.h"

@implementation MLTicket

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ticket = [attributes[@"ticket"] notNull];
		_sessionID = [attributes[@"sessionid"] notNull];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_ticket = [aDecoder decodeObjectForKey:@"ticket"];
		_sessionID = [aDecoder decodeObjectForKey:@"sessionid"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_ticket forKey:@"ticket"];
	[aCoder encodeObject:_sessionID forKey:@"sessionid"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ticket:%@, sessionid:%@>", _ticket, _sessionID];
}

@end
