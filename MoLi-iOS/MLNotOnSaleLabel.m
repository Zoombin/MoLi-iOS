//
//  MLNotOnSaleLabel.m
//  MoLi
//
//  Created by zhangbin on 4/11/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLNotOnSaleLabel.h"

@implementation MLNotOnSaleLabel

+ (CGSize)size {
	return CGSizeMake(15, 32);
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.numberOfLines = 0;
		self.font = [UIFont systemFontOfSize:9];
		self.text = @"失\n效";
		self.textColor = [UIColor blackColor];
		self.textAlignment = NSTextAlignmentCenter;
		self.layer.cornerRadius = 2;
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 0.5;
		self.backgroundColor = [UIColor colorWithRed:226/255.0f green:227/255.0f blue:227/255.0f alpha:1.0];
	}
	return self;
}


@end
