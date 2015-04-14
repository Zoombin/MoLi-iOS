//
//  MLOrderFooter.m
//  MoLi
//
//  Created by 颜超 on 15/4/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderFooter.h"
#import "UIView+Utils.h"

#warning 这个是订单详情的footer
@implementation MLOrderFooter

- (void)awakeFromNib {
    // Initialization code
    [_dashLine1 dottedLine:[UIColor lightGrayColor]];
    [_dashLine2 dottedLine:[UIColor lightGrayColor]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
