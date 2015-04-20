//
//  NSString+ZBUtilites.m
//  BookReader
//
//  Created by zhangbin on 8/4/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "NSString+ZBUtilites.h"

@implementation NSString (ZBUtilites)

- (BOOL)stringContainsString:(NSString *)aString {
	if ([self respondsToSelector:@selector(containsString:)]) {
		return [self containsString:aString];
	} else {
		return [self rangeOfString:aString].location != NSNotFound;
	}
}

- (BOOL)areAllCharactersSpace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

+ (NSString *)ChineseSpace {
	return @"　";
}

+ (NSString *)dashLineWithLength:(NSUInteger)length {
	NSMutableString *line = [NSMutableString string];
	for (int i = 0; i < length; i++) {
		[line appendString:@"-"];
	}
	return line;
}

+ (NSString *)dottedLineWithLength:(NSUInteger)length {
	NSMutableString *line = [NSMutableString string];
	for (int i = 0; i < length; i++) {
		[line appendString:@"."];
	}
	return line;
}

+ (NSString *)appStoreLinkWithAppID:(NSString *)appID {
	return [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", appID];
}

- (BOOL)isNullString
{
    if (!self||[self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else
        return NO;
}

@end
