//
//  NSNumber+ML.h
//  MoLi
//
//  Created by zhangbin on 2/4/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (ML)

+ (instancetype)edgeWithMaxWidth:(CGFloat)maxWidth itemWidth:(CGFloat)itemWidth numberPerLine:(NSInteger)numberPerLine;

@end
