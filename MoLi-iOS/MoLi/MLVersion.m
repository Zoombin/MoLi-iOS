//
//  MLVersion.m
//  MoLi
//
//  Created by zhangbin on 11/17/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLVersion.h"

@implementation MLVersion

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_hasNewVersion = [NSNumber numberWithBool:[attributes[@"hasnewversion"] notNull]];
		_latestVersion = [attributes[@"latestversion"] notNull];
		_forceUpdate = [NSNumber numberWithBool:[attributes[@"forceupdate"] notNull]];
		_updateURLString = [attributes[@"downloadaddress"] notNull];
		_describe = [attributes[@"description"] notNull];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<hasNewVersion:%@, latestVersion:%@, forceUpdate:%@, updateURLString:%@, describe:%@>", _hasNewVersion, _latestVersion, _forceUpdate, _updateURLString, _describe];
}

@end
