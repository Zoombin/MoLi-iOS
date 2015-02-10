//
//  MLStoreClassifiesViewController.m
//  MoLi
//
//  Created by zhangbin on 1/28/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLStoreClassifiesViewController.h"
#import "Header.h"
#import "MLSearchViewController.h"
#import "MLStoreClassify.h"
#import "MLStoreClassifyCollectionViewCell.h"
#import "MLStoresSearchResultViewController.h"

static CGFloat const minimumInteritemSpacing = 18;

@interface MLStoreClassifiesViewController () <
UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UISearchBarDelegate
>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) NSArray *storeClassifies;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) MLStoreClassify *selectedStoreClassify;
@property (readwrite) UIView *subClassifiesView;

@end

@implementation MLStoreClassifiesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	_sectionClasses = @[[MLStoreClassifyCollectionViewCell class]];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = minimumInteritemSpacing;
	layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 6);
	_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[self.view addSubview:_collectionView];
	for (Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
	
	_subClassifiesView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 2 * 10, 10)];
	_subClassifiesView.hidden = YES;
	_subClassifiesView.backgroundColor = [UIColor whiteColor];
	[_collectionView addSubview:_subClassifiesView];
	
	[[MLAPIClient shared] storeClassifiesWithBlock:^(NSArray *multiAttribues, MLResponse *response) {
		[self displayResponseMessage:response];		
		if (response.success) {
			_storeClassifies = [MLStoreClassify multiWithAttributesArray:multiAttribues];
			[_collectionView reloadData];
		}
	}];
}

- (void)showSubClassifiesViewAtIndexPath:(NSIndexPath *)indexPath {
	for (UIView *s in _subClassifiesView.subviews) {
		[s removeFromSuperview];
	}
	CGSize buttonSize = CGSizeMake(_subClassifiesView.bounds.size.width / 3, 45);
	CGRect rect = _subClassifiesView.frame;
	NSInteger row = indexPath.row / 3 + 1;
	rect.origin.y = (10 + [MLStoreClassifyCollectionViewCell size].height) * row;
	rect.size.height = ((_selectedStoreClassify.subClassifies.count - 1) / 3 + 1) * buttonSize.height;
	_subClassifiesView.frame = rect;
	
	rect.origin.x = 0;
	rect.origin.y = 0;
	rect.size = buttonSize;
	for (int i = 0; i < _selectedStoreClassify.subClassifies.count;) {
		MLStoreClassify *sub = _selectedStoreClassify.subClassifies[i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = rect;
		[button setTitle:sub.name forState:UIControlStateNormal];
		button.tag = i;
		button.titleLabel.adjustsFontSizeToFitWidth = YES;
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(selectedSubStoreClassify:) forControlEvents:UIControlEventTouchUpInside];
		[_subClassifiesView addSubview:button];
		
		rect.origin.x += buttonSize.width;
		i++;
		if (i % 3 == 0) {
			rect.origin.x = 0;
			rect.origin.y += buttonSize.height;
		}
	}
	
	_subClassifiesView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.delegate = self;
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.placeholder = @"查找商家";
	self.navigationItem.titleView = _searchBar;
}

- (void)selectedSubStoreClassify:(UIButton *)button {
	MLStoreClassify *storeClassify = _selectedStoreClassify.subClassifies[button.tag];
	MLStoresSearchResultViewController *storesSearchResultViewController = [[MLStoresSearchResultViewController alloc] initWithNibName:nil bundle:nil];
	storesSearchResultViewController.classifyID = storeClassify.ID;
	[self.navigationController pushViewController:storesSearchResultViewController animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[_searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.isSearchStores = YES;
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	return [class size];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	CGFloat itemWidth = [MLStoreClassifyCollectionViewCell size].width;
	NSInteger numberPerLine = 2;
	CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
	return UIEdgeInsetsMake(10, gap, 10, gap);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _storeClassifies.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	MLStoreClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	cell.storeClassify = _storeClassifies[indexPath.row];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	_selectedStoreClassify = _storeClassifies[indexPath.row];
	if (!_selectedStoreClassify.subClassifies.count) {
		_subClassifiesView.hidden = YES;
		MLStoresSearchResultViewController *storesSearchResultViewController = [[MLStoresSearchResultViewController alloc] initWithNibName:nil bundle:nil];
		storesSearchResultViewController.classifyID = _selectedStoreClassify.ID;
		[self.navigationController pushViewController:storesSearchResultViewController animated:YES];
	} else {
		_selectedStoreClassify = _storeClassifies[indexPath.row];
		if (_subClassifiesView.hidden) {
			[self showSubClassifiesViewAtIndexPath:indexPath];
		} else {
			_subClassifiesView.hidden = YES;
		}
	}
}


@end
