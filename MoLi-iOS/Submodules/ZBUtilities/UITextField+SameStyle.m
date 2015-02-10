//
//  UITextField+SameStyle.m
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UITextField+SameStyle.h"

@implementation UITextField (SameStyle)

- (void)sameStyleWith:(UITextField *)textField {
	self.backgroundColor = textField.backgroundColor;
	self.font = textField.font;
	self.textColor = textField.textColor;
	self.textAlignment = textField.textAlignment;
	self.layer.cornerRadius = textField.layer.cornerRadius;
	self.layer.borderColor = textField.layer.borderColor;
	self.layer.borderWidth = textField.layer.borderWidth;
}

@end
