//
//  MLPagingView.m
//  MoLi
//
//  Created by zhangbin on 4/11/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLPagingView.h"

@interface MLPagingView ()

@property (readwrite) UILabel *label;

@end

@implementation MLPagingView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.16];
		self.layer.cornerRadius = 4;
		self.clipsToBounds = YES;
		_label = [[UILabel alloc] initWithFrame:self.bounds];
		_label.adjustsFontSizeToFitWidth = YES;
		_label.backgroundColor = self.backgroundColor;
		_label.textAlignment = NSTextAlignmentCenter;
		[_label setTextColor:[UIColor whiteColor]];
		_label.font = [UIFont systemFontOfSize:13];
		[self addSubview:_label];
		self.alpha = 0;
		_label.alpha = 0;
	}
	return self;
}

- (void)updateMaxPage:(NSInteger)max currentPage:(NSInteger)current {
	_label.text = [NSString stringWithFormat:@"%@ / %@", @(current), @(max)];
	self.alpha = 1.0;
	_label.alpha = 1.0;
	[UIView animateWithDuration:0.25 animations:^{
		self.alpha = 0;
		_label.alpha = 0;
	}];
}

@end
