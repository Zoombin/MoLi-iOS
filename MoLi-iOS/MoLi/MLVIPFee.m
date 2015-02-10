//
//  MLVIPFee.m
//  MoLi
//
//  Created by zhangbin on 1/29/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVIPFee.h"

@implementation MLVIPFee

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_type = [attributes[@"type"] notNull];
		_status = [attributes[@"status"] notNull];
		_name = [attributes[@"name"] notNull];
		_fee = [attributes[@"fee"] notNull];
		_duration = @(1);
	}
	return self;
}

- (BOOL)isTry {
	return [_type.uppercaseString isEqualToString:@"TRY"];
}

- (BOOL)isYear {
	return [_type.uppercaseString isEqualToString:@"YEAR"];
}

- (BOOL)isMonth {
	return [_type.uppercaseString isEqualToString:@"MONTH"];
}

- (BOOL)isValid {
	return _status.integerValue == 1;
}

+ (MLVIPFee *)tryFeeInFees:(NSArray *)fees {
	for (MLVIPFee *f in fees) {
		if ([f isTry] && [f isValid]) {
			return f;
		}
	}
	return nil;
}

+ (MLVIPFee *)yearFeeInFees:(NSArray *)fees {
	for (MLVIPFee *f in fees) {
		if ([f isYear] && [f isValid]) {
			return f;
		}
	}
	return nil;
}

+ (MLVIPFee *)monthFeeInFees:(NSArray *)fees {
	for (MLVIPFee *f in fees) {
		if ([f isMonth] && [f isValid]) {
			return f;
		}
	}
	return nil;
}

+ (NSArray *)feesExceptTryInFees:(NSArray *)fees {
	NSMutableArray *array = [NSMutableArray array];
	for (MLVIPFee *f in fees) {
		if (![f isTry] && [f isValid]) {
			[array addObject:f];
		}
	}
	return array;
}

+ (NSArray *)validFeesInFees:(NSArray *)fees {
	NSMutableArray *array = [NSMutableArray array];
	for (MLVIPFee *f in fees) {
		if ([f isValid]) {
			[array addObject:f];
		}
	}
	return array;
}

@end
