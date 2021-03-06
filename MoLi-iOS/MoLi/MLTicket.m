//
//  MLTicket.m
//  MoLi
//
//  Created by zhangbin on 11/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLTicket.h"

@implementation MLTicket

+ (BOOL)valid {
	MLTicket *ticket = [MLTicket unarchive];
	if (!ticket) {
		return NO;
	} else {
		NSDate *now = [NSDate date];
		NSUInteger nowTimestamp = (NSUInteger)[now timeIntervalSince1970];
		if (nowTimestamp > ticket.timestamp.unsignedIntegerValue + 30*60) {//有效期30分钟，服务器端是60分钟
			return NO;
		}
	}
	return YES;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ticket = [attributes[@"ticket"] notNull];
	}
	return self;
}

- (void)setDate:(NSDate *)date {
	NSUInteger timestamp = (NSUInteger)[date timeIntervalSince1970];
	self.timestamp = @(timestamp);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_ticket = [aDecoder decodeObjectForKey:@"ticket"];
		_timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_ticket forKey:@"ticket"];
	[aCoder encodeObject:_timestamp forKey:@"timestamp"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ticket:%@, timestamp:%@>", _ticket, _timestamp];
}

@end
