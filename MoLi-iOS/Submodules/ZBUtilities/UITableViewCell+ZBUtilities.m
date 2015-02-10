//
//  UITableViewCell+ZBUtilities.m
//  dushuhu
//
//  Created by zhangbin on 11/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UITableViewCell+ZBUtilities.h"

@implementation UITableViewCell (ZBUtilities)

+ (UITableViewCellStyle)style {
	return UITableViewCellStyleDefault;
}

+ (NSString *)identifier {
	return NSStringFromClass(self);
}

+ (CGFloat)height {
	return [[[UITableView alloc] init] rowHeight];
}

@end
