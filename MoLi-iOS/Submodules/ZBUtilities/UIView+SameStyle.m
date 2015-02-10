//
//  UIView+SameStyle.m
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIView+SameStyle.h"

@implementation UIView (SameStyle)

- (void)sameStyleWith:(UIView *)view {
	self.backgroundColor = view.backgroundColor;
	self.layer.cornerRadius = view.layer.cornerRadius;
	self.layer.borderColor = view.layer.borderColor;
	self.layer.borderWidth = view.layer.borderWidth;
}

@end
