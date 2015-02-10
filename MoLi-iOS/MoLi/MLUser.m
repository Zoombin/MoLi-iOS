//
//  MLUser.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLUser.h"

@implementation MLUser

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_avatarURLString = [attributes[@"avatar"] notNull];
		_bindingBusiness = [attributes[@"bindingbusiness"] notNull];
		_bindingBusinessID = [attributes[@"bindingbusinessid"] notNull];
		_email = [attributes[@"email"] notNull];
		_nickname = [attributes[@"nickname"] notNull];
		_phone = [attributes[@"phone"] notNull];
		_sessionID = [attributes[@"sessionid"] notNull];
		_signToken = [attributes[@"signtoken"] notNull];
		_userID = [attributes[@"userid"] notNull];
		_userRole = [attributes[@"userrole"] notNull];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<id:%@, sessionid:%@>", _userID, _sessionID];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_avatarURLString = [aDecoder decodeObjectForKey:@"avatar"];
		_bindingBusiness = [aDecoder decodeObjectForKey:@"bindingbusiness"];
		_bindingBusinessID = [aDecoder decodeObjectForKey:@"bindingbusinessid"];
		_email = [aDecoder decodeObjectForKey:@"email"];
		_nickname = [aDecoder decodeObjectForKey:@"nickname"];
		_phone = [aDecoder decodeObjectForKey:@"phone"];
		_sessionID = [aDecoder decodeObjectForKey:@"sessionid"];
		_signToken = [aDecoder decodeObjectForKey:@"signtoken"];
		_userID = [aDecoder decodeObjectForKey:@"userid"];
		_userRole = [aDecoder decodeObjectForKey:@"userrole"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_avatarURLString forKey:@"avatar"];
	[aCoder encodeObject:_bindingBusiness forKey:@"bindingbusiness"];
	[aCoder encodeObject:_bindingBusinessID forKey:@"bindingbusinessid"];
	[aCoder encodeObject:_email forKey:@"email"];
	[aCoder encodeObject:_nickname forKey:@"nickname"];
	[aCoder encodeObject:_phone forKey:@"phone"];
	[aCoder encodeObject:_sessionID forKey:@"sessionid"];
	[aCoder encodeObject:_signToken forKey:@"signtoken"];
	[aCoder encodeObject:_userID forKey:@"userid"];
	[aCoder encodeObject:_userRole forKey:@"userrole"];
}

@end
