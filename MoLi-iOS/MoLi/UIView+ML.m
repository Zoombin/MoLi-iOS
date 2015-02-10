//
//  UIView+ML.m
//  MoLi
//
//  Created by zhangbin on 2/4/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIView+ML.h"
#import "Header.h"

@implementation UIView (ML)

+ (instancetype)borderLineWithFrame:(CGRect)frame {
	UIView *view = [[UIView alloc] initWithFrame:frame];
	view.backgroundColor = [UIColor borderGrayColor];
	return view;
}

+ (instancetype)verticalLineWithFrame:(CGRect)frame {
	UIView *view = [[UIView alloc] initWithFrame:frame];
	view.backgroundColor = [UIColor whiteColor];
	return view;
}

@end
