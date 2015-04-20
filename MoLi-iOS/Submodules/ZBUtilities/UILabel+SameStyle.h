//
//  UILabel+SameStyle.h
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SameStyle)

- (void)sameStyleWith:(UILabel *)label;

- (CGSize)boundingRectWithSize:(CGSize)size;

@end
