//
//  UIView+Utils.h
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

- (float)x;

- (float)y;

- (float)width;

- (float)height;

@end

@interface UIImageView (Utils)

- (void)dottedLine:(UIColor *)color;

@end

@interface UILabel (Utils)

- (float) heightForString;

@end
