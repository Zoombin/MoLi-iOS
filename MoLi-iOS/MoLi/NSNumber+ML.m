//
//  NSNumber+ML.m
//  MoLi
//
//  Created by zhangbin on 2/4/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "NSNumber+ML.h"

@implementation NSNumber (ML)

+ (instancetype)edgeWithMaxWidth:(CGFloat)maxWidth itemWidth:(CGFloat)itemWidth numberPerLine:(NSInteger)numberPerLine {
	CGFloat gap = (maxWidth - (itemWidth * numberPerLine)) / (numberPerLine + 1);
	return @(gap);
}

@end
