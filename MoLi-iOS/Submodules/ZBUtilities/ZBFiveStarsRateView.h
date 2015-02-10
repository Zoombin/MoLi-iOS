//
//  MLFiveStarRateView.h
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBFiveStarsRateView : UIView

@property (nonatomic, strong) UIImage *star;
@property (nonatomic, strong) UIImage *starHighlighted;
@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, assign) BOOL rateEnable;

+ (CGSize)size;
- (void)reset;

@end
