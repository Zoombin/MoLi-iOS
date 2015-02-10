//
//  MLFiveStarRateView.m
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBFiveStarsRateView.h"

NSInteger const numberOfStars = 5;

@interface ZBFiveStarsRateView ()

@property (readwrite) UIButton *star1;
@property (readwrite) UIButton *star2;
@property (readwrite) UIButton *star3;
@property (readwrite) UIButton *star4;
@property (readwrite) UIButton *star5;

@end

@implementation ZBFiveStarsRateView

+ (CGSize)size {
	return CGSizeMake(80, 16);
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = CGRectMake(0, 0, frame.size.width / numberOfStars, frame.size.height);
		
		_star1 = [UIButton buttonWithType:UIButtonTypeCustom];
		_star1.frame = rect;
		[self addSubview:_star1];
		
		rect.origin.x = CGRectGetMaxX(_star1.frame);
		_star2 = [UIButton buttonWithType:UIButtonTypeCustom];
		_star2.frame = rect;
		[self addSubview:_star2];
		
		rect.origin.x = CGRectGetMaxX(_star2.frame);
		_star3 = [UIButton buttonWithType:UIButtonTypeCustom];
		_star3.frame = rect;
		[self addSubview:_star3];
		
		rect.origin.x = CGRectGetMaxX(_star3.frame);
		_star4 = [UIButton buttonWithType:UIButtonTypeCustom];
		_star4.frame = rect;
		[self addSubview:_star4];
		
		rect.origin.x = CGRectGetMaxX(_star4.frame);
		_star5 = [UIButton buttonWithType:UIButtonTypeCustom];
		_star5.frame = rect;
		[self addSubview:_star5];
		
		[_star1 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		[_star2 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		[_star3 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		[_star4 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		[_star5 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		
		self.rateEnable = NO;
		self.rate = (0);
	}
	return self;
}

- (void)setRateEnable:(BOOL)rateEnable {
	_star1.userInteractionEnabled = rateEnable;
	_star2.userInteractionEnabled = rateEnable;
	_star3.userInteractionEnabled = rateEnable;
	_star4.userInteractionEnabled = rateEnable;
	_star5.userInteractionEnabled = rateEnable;
}

- (void)tapped:(UIButton *)sender {
	if (_star1 == sender) {
		self.rate = @(1);
	} else if (_star2 == sender) {
		self.rate = @(2);
	} else if (_star3 == sender) {
		self.rate = @(3);
	} else if (_star4 == sender) {
		self.rate = @(4);
	} else if (_star5 == sender) {
		self.rate = @(5);
	}
}

- (void)setStar:(UIImage *)star {
	_star = star;
	[_star1 setImage:_star forState:UIControlStateNormal];
	[_star2 setImage:_star forState:UIControlStateNormal];
	[_star3 setImage:_star forState:UIControlStateNormal];
	[_star4 setImage:_star forState:UIControlStateNormal];
	[_star5 setImage:_star forState:UIControlStateNormal];
}

- (void)setStarHighlighted:(UIImage *)starHighlighted {
	_starHighlighted = starHighlighted;
	[_star1 setImage:_starHighlighted forState:UIControlStateSelected];
	[_star2 setImage:_starHighlighted forState:UIControlStateSelected];
	[_star3 setImage:_starHighlighted forState:UIControlStateSelected];
	[_star4 setImage:_starHighlighted forState:UIControlStateSelected];
	[_star5 setImage:_starHighlighted forState:UIControlStateSelected];
}

- (void)setRate:(NSNumber *)rate {
	_rate = rate;
	if (_rate) {
		if (rate.integerValue >= 5) {
			_star1.selected = _star2.selected = _star3.selected = _star4.selected = _star5.selected = YES;
		} else if (rate.integerValue >= 4) {
			_star1.selected = _star2.selected = _star3.selected = _star4.selected = YES;
			_star5.selected = NO;
		} else if (rate.integerValue >= 3) {
			_star1.selected = _star2.selected = _star3.selected = YES;
			_star4.selected = _star5.selected = NO;
		} else if (rate.integerValue >= 2) {
			_star1.selected = _star2.selected = YES;
			_star3.selected = _star4.selected = _star5.selected = NO;
		} else if (rate.integerValue >= 1) {
			_star1.selected = YES;
			_star2.selected = _star3.selected = _star4.selected = _star5.selected = NO;
		} else {
			_star1.selected = _star2.selected = _star3.selected = _star4.selected = _star5.selected = NO;
		}
	}
}

- (void)reset {
	self.rate = @(0);
}

@end
