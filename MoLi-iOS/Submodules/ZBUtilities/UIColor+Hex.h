//
//  UIColor+Hex.h
//  BookReader
//
//  Created by zhangbin on 5/21/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)hexRGB:(NSUInteger)hex;
+ (UIColor *)hexWhite:(NSUInteger)hex;

+ (UIColor *)hexRGB:(NSUInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)hexWhite:(NSUInteger)hex alpha:(CGFloat)alpha;


@end
