//
//  MLNoDataView.m
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLNoDataView.h"
#import "Header.h"

@implementation MLNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = self.bounds;
		
		rect.size.width = 160;
		rect.size.height = rect.size.width;
		rect.origin.x = (self.bounds.size.width - rect.size.width) / 2;
		rect.origin.y = 150;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		_imageView.contentMode = UIViewContentModeCenter;
		_imageView.userInteractionEnabled = YES;
		[self addSubview:_imageView];
		
		rect.origin.y = CGRectGetMaxY(_imageView.frame);
		rect.size.height = 50;
		_label = [[UILabel alloc] initWithFrame:rect];
		_label.numberOfLines = 0;
		_label.textColor = [UIColor fontGrayColor];
		_label.font = [UIFont systemFontOfSize:13];
		_label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_label];
		
		rect.size.width = 106;
		rect.size.height = 36;
		rect.origin.y = CGRectGetMaxY(_label.frame) + 10;
		rect.origin.x = (self.bounds.size.width - rect.size.width) / 2;
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.frame = rect;
		_button.layer.cornerRadius = 6;
		_button.backgroundColor = [UIColor whiteColor];
		[_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		_button.hidden = YES;
		[self addSubview:_button];
	}
	return self;
}

@end
