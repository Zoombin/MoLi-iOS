//
//  MLBackToTopView.m
//  MoLi
//
//  Created by zhangbin on 4/11/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLBackToTopView.h"

@implementation MLBackToTopView

+ (UIImage *)image {
	return [UIImage imageNamed:@"BackToTop"];
}

+ (CGSize)size {
	return [self image].size;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[[self class] image]];
		imageView.frame = self.bounds;
		imageView.userInteractionEnabled = YES;
		[self addSubview:imageView];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
		[self addGestureRecognizer:tap];
	}
	return self;
}

- (void)tapped {
	if (_delegate) {
		[_delegate willBackToTop];
	}
}


@end
