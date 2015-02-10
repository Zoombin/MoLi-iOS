//
//  MLGuideViewController.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGuideViewController.h"
#import "Header.h"

static NSInteger const numberOfPages = 5;
static CGFloat const heightOfLabel = 80;

@interface MLGuideViewController () <UIScrollViewDelegate>

@property (readwrite) NSMutableArray *labels;
@property (readwrite) NSMutableArray *animationImageViews;

@end

@implementation MLGuideViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.backgroundColor = [UIColor whiteColor];
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * numberOfPages, self.view.bounds.size.height);
	[self.view addSubview:scrollView];
	
	NSArray *extraImages1 = @[];
	NSArray *extraImages2 = @[@"GuideExtra2_1"];
	NSArray *extraImages3 = @[@"GuideExtra3_1", @"GuideExtra3_2", @"GuideExtra3_3"];
	NSArray *extraImages4 = @[@"GuideExtra4_1", @"GuideExtra4_2"];
	NSArray *extraImages5 = @[@"GuideExtra5_1", @"GuideExtra5_2"];
	NSArray *extraImages = @[extraImages1,
							 extraImages2,
							 extraImages3,
							 extraImages4,
							 extraImages5
							 ];

	NSArray *colorHexs = @[@"#55acce", @"#ee86a6", @"#f4c62e", @"#9576b3", @"#a6c070"];
	NSArray *numberOfAnimationImages = @[@(6), @(23), @(6), @(3), @(6)];
	NSArray *dutaions = @[@(0.5), @(2.7), @(1), @(1), @(1)];
	NSArray *repeatCounts = @[@(0), @(0), @(0), @(0), @(0)];
	NSArray *backgroundImages = @[[UIImage imageNamed:@"GuideBackground1"],
								 [UIImage imageNamed:@"GuideBackground2"],
								 [UIImage imageNamed:@"GuideBackground3"],
								 [UIImage imageNamed:@"GuideBackground4"],
								 [UIImage imageNamed:@"GuideBackground5"],
								  ];
	CGRect rect = CGRectZero;
	rect.origin.x = 0;
	rect.origin.y = 0;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = self.view.bounds.size.height;
	_animationImageViews = [NSMutableArray array];
	for (int i = 0; i < numberOfPages; i++) {
		rect.origin.x = self.view.bounds.size.width * i;
		UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
		backgroundImageView.image = backgroundImages[i];
		backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		NSString *colorString = colorHexs[i];
		backgroundImageView.backgroundColor = [UIColor hexRGB:[colorString hexUInteger]];
		[scrollView addSubview:backgroundImageView];
	
		NSArray *names = extraImages[i];
		for (int j = 0; j < names.count; j++) {
			UIImageView *extraImageView = [[UIImageView alloc] initWithFrame:rect];
			extraImageView.contentMode = UIViewContentModeScaleAspectFit;
			extraImageView.image = [UIImage imageNamed:names[j]];
			[scrollView addSubview:extraImageView];
		}
		
		NSString *imageNamePrefix = [NSString stringWithFormat:@"GuideAnimation%d_", i + 1];
		NSInteger numberOfImages = [numberOfAnimationImages[i] integerValue];
		NSMutableArray *images = [NSMutableArray array];
		for (int j = 1; j <= numberOfImages; j++) {
			NSString *name = [NSString stringWithFormat:@"%@%d", imageNamePrefix, j];
			[images addObject:[UIImage imageNamed:name]];
		}
		UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:backgroundImageView.frame];
		animationImageView.contentMode = UIViewContentModeScaleAspectFit;
		animationImageView.animationImages = images;
		animationImageView.animationDuration = [dutaions[i] floatValue];
		animationImageView.animationRepeatCount = [repeatCounts[i] integerValue];
		if (i != 1) {
			[animationImageView startAnimating];
		}
		[scrollView addSubview:animationImageView];
		[_animationImageViews addObject:animationImageView];
	}
	
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height;
	rect.size.height = heightOfLabel;

	NSArray *strings = @[@"这么多卡,你累么?",
						 @"化繁为简,一卡搞定。",
						 @"网购你能忍受那一次?",
						 @"魔力网不让你受一点委屈!",
						 @"最舒服的线上购物选择\n最实惠的线下折扣体验",
						 ];
	_labels = [NSMutableArray array];
	for (int i = 0; i < numberOfPages; i++) {
		rect.origin.x = self.view.bounds.size.width * i;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.hidden = YES;
		label.textColor = [UIColor whiteColor];
		label.numberOfLines = 0;
		label.font = [UIFont systemFontOfSize:26];
		label.text = strings[i];
		label.textAlignment = NSTextAlignmentCenter;
		[scrollView addSubview:label];
		[_labels addObject:label];
	}
	
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 200;
	rect.origin.x = self.view.bounds.size.width * (numberOfPages - 1);
	rect.origin.y = self.view.bounds.size.height - rect.size.height;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
	[button addTarget:self action:@selector(endGuide) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self riseupLabel:_labels[0]];
}

- (void)endGuide {
	if (_delegate) {
		[_delegate endGuide];
	}
}

- (void)riseupLabel:(UILabel *)label {
	CGRect frame = CGRectZero;
	if (label.hidden) {
		frame = label.frame;
		frame.origin.y = self.view.bounds.size.height - 105;
		[UIView animateWithDuration:0.5 animations:^{
			label.frame = frame;
			label.hidden = NO;
		}];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	CGRect frame = CGRectZero;
	for (int i = 0; i < _labels.count; i++) {
		if (i == currentPage) {
			continue;
		}
		UILabel *label = _labels[i];
		frame = label.frame;
		label.hidden = YES;
		frame.origin.y = self.view.bounds.size.height;
		label.frame = frame;
	}
	
	[self riseupLabel:_labels[currentPage]];
	
	if (currentPage == 1) {
		UIImageView *animationImageView = _animationImageViews[currentPage];
		[animationImageView startAnimating];
	}
}


@end
