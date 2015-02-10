//
//  MLGalleryCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGalleryCollectionViewCell.h"
#import "Header.h"

@interface MLGalleryCollectionViewCell () <UIScrollViewDelegate>

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UIPageControl *pageControl;

@end

@implementation MLGalleryCollectionViewCell

+ (CGFloat)height {
	return 320;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		[self.contentView addSubview:_scrollView];
		
		CGRect rect = CGRectZero;
		rect.size.width = CGRectGetWidth(_scrollView.frame);
		rect.size.height = 30;
		rect.origin.x = 0;
		rect.origin.y = CGRectGetHeight(_scrollView.frame) - rect.size.height;
		_pageControl = [[UIPageControl alloc] initWithFrame:rect];
		_pageControl.currentPage = 0;
		[self.contentView addSubview:_pageControl];
	}
	return self;
}

- (void)setImagePaths:(NSArray *)imagePaths {
	_imagePaths = imagePaths;
	CGRect rect = self.bounds;
	for (int i = 0; i < _imagePaths.count; i++) {
		NSString *imagePath = _imagePaths[i];
		rect.origin.x = rect.size.width * i;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
		imageView.userInteractionEnabled = YES;
		[imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		[_scrollView addSubview:imageView];
	}
	_pageControl.numberOfPages = _imagePaths.count;
	_scrollView.contentSize = CGSizeMake(_imagePaths.count * rect.size.width, rect.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	_pageControl.currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}


@end
