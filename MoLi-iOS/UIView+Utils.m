//
//  UIView+Utils.m
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (float)x {
    return self.frame.origin.x;
}

- (float)y {
    return self.frame.origin.y;
}

- (float)width {
    return self.frame.size.width;
}

- (float)height {
    return self.frame.size.height;
}

@end

@implementation UIImageView (Utils)

- (void)dottedLine:(UIColor *)color {
    UIGraphicsBeginImageContext(self.frame.size);   //开始画线
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, self.frame.size.height / 2);    //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, self.frame.size.height / 2);
    CGContextStrokePath(line);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
}

@end

@implementation UILabel (Utils)

- (float)heightForString {
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:CGSizeMake(self.width, 0)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize.height;
}

@end
