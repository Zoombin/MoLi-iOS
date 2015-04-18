//
//  UIImage+ML.h
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Random.h"
#import "UIImage+LogN.h"

/// 图片工具类.
@interface UIImage (ML)

+ (instancetype)rateStar;
+ (instancetype)rateStarHighlighted;
+ (instancetype)randomColorImageFromSize:(CGSize)size;
+ (instancetype)randomColorPlaceholder;

@end
