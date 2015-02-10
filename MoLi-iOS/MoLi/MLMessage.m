//
//  MLMessage.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMessage.h"

@implementation MLMessage

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_isRead = [attributes[@"isread"] notNull];
		_link = [attributes[@"link"] notNull];
		_ID = [attributes[@"messageid"] notNull];
		_sendTimestamp = [attributes[@"senddate"] notNull];
		_title = [attributes[@"title"] notNull];
		_type = [attributes[@"word"] notNull];
		_content = [attributes[@"content"] notNull];
	}
	return self;
}

- (NSString *)displaySendDate {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:_sendTimestamp.unsignedIntegerValue];
	return [dateFormatter stringFromDate:date];
}

@end
