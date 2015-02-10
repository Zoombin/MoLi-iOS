//
//  MLLoadingView.m
//  MoLi
//
//  Created by zhangbin on 1/30/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLLoadingView.h"
#import "Header.h"

static CGFloat const heightOfLabel = 10;

@interface MLLoadingView ()

@property (readwrite) UIImageView *needleImageView;

@end

@implementation MLLoadingView

+ (UIImage *)loadingImage {
	return [UIImage imageNamed:@"Loading"];
}

+ (UIImage *)loadingNeedleImage {
	return [UIImage imageNamed:@"LoadingNeedle"];
}

+ (CGSize)imageSize {
	return [self loadingImage].size;
}

+ (CGSize)size {
	CGSize size = [self imageSize];
	size.height += heightOfLabel;
	return size;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = CGRectZero;
		rect.size = [[self class] imageSize];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
		imageView.image = [[self class] loadingImage];
		[self addSubview:imageView];
		
		_needleImageView = [[UIImageView alloc] initWithFrame:rect];
		_needleImageView.image = [[self class] loadingNeedleImage];
		[self addSubview:_needleImageView];
		
		rect.origin.y = CGRectGetMaxY(_needleImageView.frame);
		rect.size.height = heightOfLabel;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.backgroundColor = [UIColor clearColor];
		label.text = @"正在加载中...";
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor grayColor];
		label.font = [UIFont systemFontOfSize:10];
		[self addSubview:label];
	}
	return self;
}


- (void)start {
	CABasicAnimation *rotate;
	rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotate.fromValue = [NSNumber numberWithFloat:0];
	rotate.toValue = [NSNumber numberWithFloat:2 * M_PI];
	rotate.duration = 0.5;
	rotate.repeatCount = 10000;
	[_needleImageView.layer addAnimation:rotate forKey:@"loading"];
}

@end
