//
//  UIDevice+ZBUtilites.m
//  BookReader
//
//  Created by zhangbin on 8/17/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "UIDevice+ZBUtilites.h"

const CGFloat kHeightOf4Inch = 568.0f;
const CGFloat kHeightOf3dot5Inch = 480.0f;

@implementation UIDevice (ZBUtilites)

+ (BOOL)is4Inch
{
	return ( [UIScreen mainScreen].bounds.size.height == kHeightOf4Inch );
}

+ (CGFloat)heightOf4Inch
{
	return kHeightOf4Inch;
}

+ (CGFloat)heightOf3dot5Inch
{
	return kHeightOf3dot5Inch;
}


@end
