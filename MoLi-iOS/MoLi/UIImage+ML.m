//
//  UIImage+ML.m
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UIImage+ML.h"

@implementation UIImage (ML)

+ (instancetype)rateStar {
	return [UIImage imageNamed:@"Star"];
}

+ (instancetype)rateStarHighlighted {
	return [UIImage imageNamed:@"StarHighlighted"];
}

+ (instancetype)randomColorImageFromSize:(CGSize)size {
	return [UIImage imageFromColor:[UIColor randomColor] toColor:[UIColor randomColor] size:size cornerRadius:0];
}

+ (instancetype)randomColorPlaceholder {
	return [self randomColorImageFromSize:CGSizeMake(40, 40)];
}

@end
