//
//  MLFlagStoreCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/31/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLFlagStoreCollectionViewCell.h"

@implementation MLFlagStoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		CGRect rect = self.imageView.frame;
		rect.origin.x = 15;
		rect.size.width = 72;
		self.imageView.frame = rect;
		
		rect = self.label.frame;
		rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
		self.label.frame = rect;
	}
	return self;
}

@end
