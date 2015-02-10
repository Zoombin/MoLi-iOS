//
//  MLSearchViewController.m
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLSearchResultViewController.h"
#import "Header.h"
#import "MLGoods.h"
#import "MLGoodsDetailsViewController.h"
#import "ZBBottomIndexView.h"
#import "MLGoodsNormalCollectionViewCell.h"
#import "MLGoodsCollectionViewCell.h"
#import "MLSearchViewController.h"
#import "MLNoMoreDataFooter.h"
#import "MLGoodsPropertiesPickerViewController.h"
#import "IIViewDeckController.h"

@interface MLSearchResultViewController () <
ZBBottomIndexViewDelegate,
UISearchBarDelegate,
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) NSMutableArray *multiGoods;
@property (readwrite) NSArray *filters;
@property (readwrite) NSInteger page;
@property (readwrite) BOOL noMore;
@property (readwrite) CGRect originRectOfBottomIndexView;
@property (readwrite) CGRect originRectOfCollectionView;
@property (readwrite) CGFloat startYAfterNavigationBar;
@property (readwrite) CGFloat heightOfNavigationBar;

@end

@implementation MLSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	_page = 1;
	_startYAfterNavigationBar = 64;
	_heightOfNavigationBar = 48;
	_multiGoods = [NSMutableArray array];
	_sectionClasses = @[[MLGoodsNormalCollectionViewCell class]];
	
	CGRect rect = CGRectZero;
	rect.origin.y = _startYAfterNavigationBar;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 34;
	_originRectOfBottomIndexView = rect;
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:rect];
	[_bottomIndexView setItems:@[@"最新", @"价格", @"销量", @"好评率"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
	[self.view addSubview:_bottomIndexView];
	
	rect.origin.y = CGRectGetMaxY(_bottomIndexView.frame);
	rect.size.height = self.view.bounds.size.height - rect.origin.y - _heightOfNavigationBar;
	_originRectOfCollectionView = rect;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[_collectionView registerClass:[MLNoMoreDataFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[MLNoMoreDataFooter identifier]];
//	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
	[self.view addSubview:_collectionView];
	[_collectionView registerClass:[MLGoodsNormalCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsNormalCollectionViewCell identifier]];
	[_collectionView registerClass:[MLGoodsCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsCollectionViewCell identifier]];
	[self.view addSubview:_collectionView];
	
	_filters = @[@"time", @"price", @"salesvolume", @"hignopinion"];
	
	if (_searchString) {
		_searchBar.text = _searchString;
	} else {
		_searchBar.text = _goodsClassify.name;
	}
	
	[self searchOrderby:_filters[0] keyword:_searchString];
	
	[self.view addGestureRecognizer:[_bottomIndexView leftSwipeGestureRecognizer]];
	[self.view addGestureRecognizer:[_bottomIndexView rightSwipeGestureRecognizer]];
	[self displayStyleList];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.delegate = self;
	self.navigationItem.titleView = _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIBarButtonItem *)displayListBarButtonItem {
	    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"SortList"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(displayStyleList)];
	return barButtonItem;
}

- (UIBarButtonItem *)displaySquareBarButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"SortGrid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(displayStyleSquare)];
	return barButtonItem;
}

- (UIBarButtonItem *)filterBarButtonItem {
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
	return barButtonItem;
}

- (void)displayStyleList {
	self.navigationItem.rightBarButtonItems = @[[self filterBarButtonItem], [self displaySquareBarButtonItem]];
	_sectionClasses = @[[MLGoodsNormalCollectionViewCell class]];
	[_collectionView reloadData];
}

- (void)displayStyleSquare {
	self.navigationItem.rightBarButtonItems = @[[self filterBarButtonItem], [self displayListBarButtonItem]];
	_sectionClasses = @[[MLGoodsCollectionViewCell class]];
	[_collectionView reloadData];
}

- (void)filter {
	
}

- (void)searchOrderby:(NSString *)orderby keyword:(NSString *)keyword {
	if (_noMore) {
		return;
	}
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	[[MLAPIClient shared] searchGoodsWithClassifyID:_goodsClassify.ID keywords:keyword price:nil spec:nil orderby:orderby ascended:NO page:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error) {
		[self hideHUD:YES];
		if (!error) {
			_page++;
			NSArray *array = [MLGoods multiWithAttributesArray:multiAttributes];
			if (!array.count) {
				_noMore = YES;
			} else {
				[_multiGoods addObjectsFromArray:array];
			}
			[_collectionView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height) {
		NSString *orderby = _filters[_bottomIndexView.selectedIndex];
		[self searchOrderby:orderby keyword:nil];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_searchBar resignFirstResponder];
	CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
	if(translation.y > 0) {
		if (self.navigationController.navigationBar.hidden) {
			[self.navigationController setNavigationBarHidden:NO animated:YES];
			[UIView animateWithDuration:0.25 animations:^{
				_bottomIndexView.frame = _originRectOfBottomIndexView;
				_collectionView.frame = _originRectOfCollectionView;
			}];
		}
	} else {
		if (!self.navigationController.navigationBar.hidden) {
			[self.navigationController setNavigationBarHidden:YES animated:YES];
			CGRect rect = _originRectOfBottomIndexView;
			rect.origin.y -= _heightOfNavigationBar;
			
			CGRect rect2 = _originRectOfCollectionView;
			rect2.origin.y -= _heightOfNavigationBar;
			rect2.size.height += _heightOfNavigationBar;
			[UIView animateWithDuration:0.25 animations:^{
				_bottomIndexView.frame = rect;
				_collectionView.frame = rect2;
			}];
		}
		//NSLog(@"up");
	}
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[_searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
	if (selectedIndex <= _filters.count) {
		NSString *orderby = _filters[selectedIndex];
		[self searchOrderby:orderby keyword:nil];
	}
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (_noMore) {
		return CGSizeMake(collectionView.bounds.size.width, [MLNoMoreDataFooter height]);
	}
	return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	CGFloat height = [class height];
	CGFloat width = _collectionView.bounds.size.width;
	if (class == [MLGoodsCollectionViewCell class]) {
		width = [class size].width;
	}
	return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MLNoMoreDataFooter identifier] forIndexPath:indexPath];
	return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsCollectionViewCell class]) {
		NSInteger numberPerLine = 2;
		CGFloat itemWidth = [class size].width;
		CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
		return UIEdgeInsetsMake(10, gap, 10, gap);
	}
	return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _multiGoods.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	MLGoods *goods = _multiGoods[indexPath.row];
	if (class == [MLGoodsNormalCollectionViewCell class]) {
		MLGoodsNormalCollectionViewCell *normalCell = (MLGoodsNormalCollectionViewCell *)cell;
		normalCell.goods = goods;
	} else if (class == [MLGoodsCollectionViewCell class]) {
		MLGoodsCollectionViewCell *goodsCell = (MLGoodsCollectionViewCell *)cell;
		goodsCell.goods = goods;
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsPropertiesPickerViewController *goodsPropertiesPickerViewController = [[MLGoodsPropertiesPickerViewController alloc] initWithNibName:nil bundle:nil];
	goodsPropertiesPickerViewController.hidesBottomBarWhenPushed = YES;
	MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
	goodsDetailsViewController.propertiesPickerViewController = goodsPropertiesPickerViewController;
	goodsDetailsViewController.goods = _multiGoods[indexPath.row];
	
	IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:goodsDetailsViewController rightViewController:goodsPropertiesPickerViewController];
	deckController.rightSize = [MLGoodsPropertiesPickerViewController indent];
    [deckController setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:deckController animated:YES];
}

@end
