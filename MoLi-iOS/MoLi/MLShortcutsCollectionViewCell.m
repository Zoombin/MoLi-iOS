//
//  MLShortcutsCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLShortcutsCollectionViewCell.h"
#import "Header.h"

@interface MLShortcutsCollectionViewCell ()

@property (readwrite) UIScrollView *scrollView;

@end

@implementation MLShortcutsCollectionViewCell

+ (CGFloat)height {
	return 74;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = CGRectZero;
		rect.size.width = frame.size.width;
		rect.size.height = 0.5;
		[self.contentView addSubview:[UIView borderLineWithFrame:rect]];
		
		rect = CGRectMake(0, 0, frame.size.width, [[self class] height]);
		_scrollView = [[UIScrollView alloc] initWithFrame:rect];
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.pagingEnabled = YES;
		[self.contentView addSubview:_scrollView];
		
		rect.origin.y = [[self class] height] - 0.5;
		rect.size.height = 0.5;
		[self.contentView addSubview:[UIView borderLineWithFrame:rect]];
	}
	return self;
}

- (void)setAdvertisement:(MLAdvertisement *)advertisement {
	[super setAdvertisement:advertisement];
	if (!self.advertisement) return;
	
	CGRect rect = CGRectZero;
	rect.size.width = _scrollView.bounds.size.width / 4;
	rect.size.height = [[self class] height];
	for (int i = 0; i < advertisement.elements.count; i++) {
		MLAdvertisementElement *element = advertisement.elements[i];
		rect.origin.x = rect.size.width * i;
		
		UIView *view = [[UIView alloc] initWithFrame:rect];
		CGSize imageSize = CGSizeMake(38, 38);
		CGRect rect2 = CGRectZero;
		rect2.size = imageSize;
		rect2.origin.y = 10;
		rect2.origin.x = (rect.size.width - imageSize.width) / 2;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect2];
		[imageView setImageWithURL:[NSURL URLWithString:element.imagePath]];
		[view addSubview:imageView];
		
		rect2.origin.x = 0;
		rect2.origin.y = CGRectGetMaxY(imageView.frame) + 2;
		rect2.size.width = rect.size.width;
		rect2.size.height = 20;
		UILabel *label = [[UILabel alloc] initWithFrame:rect2];
		label.textColor = [UIColor fontGrayColor];
		label.font = [UIFont systemFontOfSize:12];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = element.title;
		[view addSubview:label];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        view.tag = 1000+i;
		[view addGestureRecognizer:tap];
		
		[_scrollView addSubview:view];
	}
}

- (void)tapped:(UITapGestureRecognizer *)sender {

	MLAdvertisementElement *element = self.advertisement.elements[sender.view.tag-1000];
	if (self.delegate) {
		[self.delegate collectionViewCellWillSelectAdvertisement:self.advertisement advertisementElement:element];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	NSArray *subviews = [_scrollView subviews];
	for (UIView *sv in subviews) {
		[sv removeFromSuperview];
	}
}


@end
