//
//  UIView+ML.h
//  MoLi
//
//  Created by zhangbin on 2/4/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 画线工具类.
@interface UIView (ML)

+ (instancetype)borderLineWithFrame:(CGRect)frame;
+ (instancetype)verticalLineWithFrame:(CGRect)frame;

@end
