//
//  MLFlagshipStoreViewController.m
//  MoLi
//
//  Created by zhangbin on 1/31/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLFlagshipStoreViewController.h"
#import "MLGoodsCollectionViewCell.h"
#import "Header.h"
#import "MLGoods.h"
#import "MLShare.h"
#import "MLGoodsDetailsViewController.h"
#import "MLNoMoreDataFooter.h"
#import "MLBackToTopView.h"
#import "MLPagingView.h"

@interface MLFlagshipStoreViewController () <
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
MLBackToTopViewDelegate
>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) NSInteger page;
@property (readwrite) NSInteger maxPage;
@property (readwrite) NSMutableArray *multiGoods;
@property (readwrite) BOOL noMore;
@property (readwrite) MLBackToTopView *backToTopView;
@property (readwrite) MLPagingView *pagingView;

@end

@implementation MLFlagshipStoreViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"旗舰店";
	_multiGoods = [NSMutableArray array];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_page = 1;
	
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
	
	UIBarButtonItem *favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Like"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favour)];
	
	self.navigationItem.rightBarButtonItems = @[shareBarButtonItem, favoriteBarButtonItem];

	
	_sectionClasses = @[[UICollectionViewCell class], [MLGoodsCollectionViewCell class]];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = [UIColor backgroundColor];
	for	(Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
	[_collectionView registerClass:[MLNoMoreDataFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[MLNoMoreDataFooter identifier]];
	[self.view addSubview:_collectionView];
	
	CGRect rect = CGRectZero;
	rect.origin.x = self.view.bounds.size.width - 50;
	rect.origin.y = self.view.bounds.size.height - 50;
	rect.size = [MLBackToTopView size];
	_backToTopView = [[MLBackToTopView alloc] initWithFrame:rect];
	_backToTopView.delegate = self;
	_backToTopView.hidden = YES;
	[self.view addSubview:_backToTopView];
	
	rect.size.width = 44;
	rect.size.height = 20;
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = self.view.bounds.size.height - 40;
	_pagingView = [[MLPagingView alloc] initWithFrame:rect];
	[_pagingView updateMaxPage:99 currentPage:99];
	[self.view addSubview:_pagingView];
	
	[[MLAPIClient shared] detailsOfFlagshipStoreID:_flagshipStore.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_flagshipStore = [[MLFlagshipStore alloc] initWithAttributes:attributes];
			self.title = _flagshipStore.name;
			[self fetchGoods];
		}
		
	}];
}

- (void)fetchGoods {
	if (_noMore) {
		return;
	}
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] multiGoodsInFlagshipStoreID:_flagshipStore.ID page:@(_page) withBlock:^(NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			NSArray *array = [MLGoods multiWithAttributesArray:multiAttributes];
			if (!array.count) {
				_noMore = YES;
			} else {
				if (_page > 1) {
					_backToTopView.hidden = NO;
				}
				
				_maxPage = [[response.data[@"totalpage"] notNull] integerValue];
				if (_page < _maxPage + 1) {
					_page++;
				}
				[_multiGoods addObjectsFromArray:array];
			}
			[_collectionView reloadData];
		}
	}];
}

- (void)share {
	[[MLAPIClient shared] shareWithObject:MLShareObjectFStore platform:MLSharePlatformQQ objectID:_flagshipStore.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLShare *share = [[MLShare alloc] initWithAttributes:attributes];
			[UMSocialSnsService presentSnsIconSheetView:self appKey:ML_UMENG_APP_KEY shareText:share.word shareImage:[UIImage imageNamed:@"MoliIcon"] shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatTimeline, UMShareToWechatSession] delegate:nil];
		}
	}];
}

- (void)favour {
	[[MLAPIClient shared] favourFlagshipStoreID:_flagshipStore.ID withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
	}];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height) {
		[self fetchGoods];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
	if(translation.y > 0) {//向上
	} else {//向下
		[_pagingView updateMaxPage:_maxPage currentPage:_page - 1];
	}
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (_noMore) {
		return CGSizeMake(collectionView.bounds.size.width, [MLNoMoreDataFooter height]);
	}
	return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MLNoMoreDataFooter identifier] forIndexPath:indexPath];
	return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLGoodsCollectionViewCell class]) {
		return [MLGoodsCollectionViewCell size];
	} else {
		return CGSizeMake(collectionView.bounds.size.width, 60);
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	Class class = _sectionClasses[section];
	NSInteger numberPerLine = 2;
	if (class == [MLGoodsCollectionViewCell class]) {
		CGFloat itemWidth = [class size].width;
		CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
		return UIEdgeInsetsMake(10, gap, 10, gap);
	}
	return UIEdgeInsetsZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsCollectionViewCell class]) {
		return _multiGoods.count;
	}
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	if (class == [MLGoodsCollectionViewCell class]) {
		MLGoodsCollectionViewCell *goodsCell = (MLGoodsCollectionViewCell *)cell;
		goodsCell.goods = _multiGoods[indexPath.row];
	} else {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
		[imageView setImageWithURL:[NSURL URLWithString:_flagshipStore.iconPath]];
		[cell.contentView addSubview:imageView];
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLGoodsCollectionViewCell class]) {
		MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
		goodsDetailsViewController.goods = _multiGoods[indexPath.row];
		[self.navigationController pushViewController:goodsDetailsViewController animated:YES];
	}
}

#pragma mark - MLBackToTopDelegate

- (void)willBackToTop {
	[_collectionView setContentOffset:CGPointZero animated:YES];
	_backToTopView.hidden = YES;
}

@end
