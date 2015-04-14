//
//  MLMainCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/24/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLBannerCollectionViewCell.h"
#import "Header.h"

#define kAutoScrollTimeInterval 3.0

@interface MLBannerCollectionViewCell () <UIScrollViewDelegate>

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UIPageControl *pageControl;
@property (readwrite) NSTimer *timer;
@property (readwrite) NSInteger currentPage;

@end

@implementation MLBannerCollectionViewCell

+ (CGFloat)height {
	return 80;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = CGRectMake(0, 0, frame.size.width, [[self class] height]);
		_scrollView = [[UIScrollView alloc] initWithFrame:rect];
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		[self.contentView addSubview:_scrollView];
		
		rect.size.height = 20;
		rect.origin.y = [[self class] height] - rect.size.height;
		_pageControl = [[UIPageControl alloc] initWithFrame:rect];
		_pageControl.pageIndicatorTintColor = [UIColor grayColor];
		_pageControl.currentPageIndicatorTintColor = [UIColor themeColor];
		[self.contentView addSubview:_pageControl];
		
		[self startAutoScrollTimer];
	}
	return self;
}

- (void)setAdvertisement:(MLAdvertisement *)advertisement {
	[super setAdvertisement:advertisement];
	if (!self.advertisement) return;
	
	for (int i = 0; i < self.advertisement.elements.count; i++) {
		MLAdvertisementElement *element = self.advertisement.elements[i];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
		[imageView setImageWithURL:[NSURL URLWithString:element.imagePath] placeholderImage:[UIImage imageNamed:@"AdvertisementBannerPlaceholder"]];
		imageView.tag = i;
		imageView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[imageView addGestureRecognizer:tap];
		[_scrollView addSubview:imageView];
	}
	_pageControl.numberOfPages = self.advertisement.elements.count;
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.advertisement.elements.count, _scrollView.bounds.size.height);
}

- (void)tapped:(UITapGestureRecognizer *)tap {
	MLAdvertisementElement *element = self.advertisement.elements[tap.view.tag];
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

- (void)startAutoScrollTimer {
	_timer = [NSTimer timerWithTimeInterval:kAutoScrollTimeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:NO];
	[_timer performSelector:@selector(fire) withObject:nil afterDelay:kAutoScrollTimeInterval];
}

- (void)scrollToNext {
	_currentPage++;
	if (_currentPage > self.advertisement.elements.count - 1) {
		[_scrollView setContentOffset:CGPointZero animated:YES];
		_currentPage = 0;
	} else {
		[_scrollView setContentOffset:CGPointMake(_currentPage * _scrollView.frame.size.width, 0) animated:YES];
	}
	_pageControl.currentPage = _currentPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	_pageControl.currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_timer) {
		[_timer invalidate];
		[self startAutoScrollTimer];
	}
}

@end
