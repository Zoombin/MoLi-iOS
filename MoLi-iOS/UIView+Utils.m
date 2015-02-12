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
