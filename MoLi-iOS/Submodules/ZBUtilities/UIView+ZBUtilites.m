//
//  UIView+ZBUtilites.m
//  MoLi
//
//  Created by zhangbin on 2/4/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIView+ZBUtilites.h"

@implementation UIView (ZBUtilites)

- (void)removeAllSubviews {
	for (UIView *subview in self.subviews) {
		[subview removeFromSuperview];
	}
}

@end
