//
//  UIView+dashLine.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "UIView+dashLine.h"

@implementation UIView (DashLine)

- (void)drawDashLine
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 10.0, 0);
    CGContextAddLineToPoint(context, 310.0, 0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

@end
