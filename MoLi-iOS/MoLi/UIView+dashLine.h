//
//  UIView+DashLine.h
//  MoLi
//
//  Created by zhangbin on 4/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 虚线工具类.
@interface UIView (DashLine)

- (void)drawDashedBorder;
- (void)drawDashedBorderwithColor:(UIColor *)color;

@end
