//
//  MLFavoriteSummary.m
//  MoLi
//
//  Created by zhangbin on 2/6/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLFavoriteSummary.h"

@implementation MLFavoriteSummary

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_numberOfgoods = [attributes[@"goods"] notNull];
		_numberOfFlagshipStore = [attributes[@"store"] notNull];
		_numberOfStore = [attributes[@"business"] notNull];
	}
	return self;
}

- (NSNumber *)total {
	return @(_numberOfgoods.integerValue + _numberOfFlagshipStore.integerValue + _numberOfStore.integerValue);
}


@end
