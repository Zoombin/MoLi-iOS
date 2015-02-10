//
//  UIColor+ML.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UIColor+ML.h"

@implementation UIColor (ML)

+ (instancetype)themeColor {
	return [UIColor colorWithRed:233/255.0f green:79/255.0f blue:46/255.0f alpha:1.0f];
}

+ (instancetype)backgroundColor {
	return [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
}

+ (instancetype)customGrayColor {
	return [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
}

+ (instancetype)borderGrayColor {
	return [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
}

+ (instancetype)fontGrayColor {
	return [UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f];
}

@end
