//
//  NSString+Hex.m
//  dushuhu
//
//  Created by zhangbin on 3/27/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)

- (NSUInteger)hexUInteger
{
	unsigned int hexInteger = 0;
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
	[scanner scanHexInt:&hexInteger];
	return hexInteger;
}

- (NSNumber *)priceNumber
{
	float scannedfloat = 0.0f;
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"￥$"]];
	[scanner scanFloat:&scannedfloat];
	return @(scannedfloat);
}

@end
