//
//  UILabel+SameStyle.m
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UILabel+SameStyle.h"

@implementation UILabel (SameStyle)

- (void)sameStyleWith:(UILabel *)label {
	self.backgroundColor = label.backgroundColor;
	self.font = label.font;
	self.textColor = label.textColor;
	self.textAlignment = label.textAlignment;
	self.layer.cornerRadius = label.layer.cornerRadius;
	self.layer.borderColor = label.layer.borderColor;
	self.layer.borderWidth = label.layer.borderWidth;
}


- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


@end
