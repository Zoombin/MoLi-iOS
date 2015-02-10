//
//  UICollectionViewCell+ZBUtilites.m
//  MoLi
//
//  Created by zhangbin on 12/24/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UICollectionViewCell+ZBUtilites.h"

@implementation UICollectionViewCell (ZBUtilites)

+ (NSString *)identifier {
	return NSStringFromClass(self);
}

+ (CGFloat)height {
	return [UIScreen mainScreen].bounds.size.height;
}

@end
