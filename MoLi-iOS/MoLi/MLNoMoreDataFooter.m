//
//  MLNoMoreDataFooter.m
//  MoLi
//
//  Created by zhangbin on 1/30/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLNoMoreDataFooter.h"
#import "Header.h"

@implementation MLNoMoreDataFooter

+ (NSString *)identifier {
	return NSStringFromClass(self);
}

+ (CGFloat)height {
	return 46;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 90, 0, [[self class] height], [[self class] height])];
		imageView.image = [UIImage imageNamed:@"Placeholder"];
		[self addSubview:imageView];
		
		UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
		label.text = @"您已经看到最后了";
		label.font = [UIFont systemFontOfSize:13];
		label.textColor = [UIColor fontGrayColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
	}
	return self;
}

@end
