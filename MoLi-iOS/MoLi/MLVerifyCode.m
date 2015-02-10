//
//  MLVerifyCode.m
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVerifyCode.h"
#import "Header.h"

@implementation MLVerifyCode

+ (void)fetchCodeSuccess {
	NSDate *date = [NSDate date];
	NSInteger next = (NSInteger)[date timeIntervalSince1970] + 120;
	[[NSUserDefaults standardUserDefaults] setObject:@(next) forKey:ML_USER_DEFAULT_IDENTIFIER_NEXT_VERIFYCODE_TIMESTAMP];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)countdown {
	NSNumber *timestamp = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_NEXT_VERIFYCODE_TIMESTAMP];
	if (timestamp) {
		NSDate *date = [NSDate date];
		NSTimeInterval now = (NSInteger)[date timeIntervalSince1970];
		if ([timestamp integerValue] < now) {
			return 0;
		} else {
			return [timestamp integerValue] - now;
		}
	}
	return 0;
}

+ (NSString *)identifierWithType:(MLVerifyCodeType)type {
	if (type == MLVerifyCodeTypeForgotPassword) {
		return @"forgot";
	} else if (type == MLVerifyCodeTypeForgotWalletPassword) {
		return @"forgotwalletpwd";
	}
	return @"regist";
}

- (NSString *)identifier {
	return [[self class] identifierWithType:_type];
}


@end
