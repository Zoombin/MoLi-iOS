//
//  UIColor+ML.h
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (ML)

+ (instancetype)themeColor;
+ (instancetype)backgroundColor;
+ (instancetype)customGrayColor;
+ (instancetype)borderGrayColor;
+ (instancetype)fontGrayColor;
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (instancetype)colorWithHexString:(NSString *)color;

@end
