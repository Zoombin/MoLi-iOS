//
//  MLStoresSearchResultViewController.m
//  MoLi
//
//  Created by zhangbin on 1/27/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLStoresSearchResultViewController.h"
#import "Header.h"
#import "MLStoreCollectionViewCell.h"
#import "MLSort.h"
#import "MLStoreDetailsViewController.h"
#import "ZBBottomIndexView.h"
#import "MLStoreClassify.h"
#import "MLCircle.h"
#import "MLNoDataView.h"

@interface MLStoresSearchResultViewController () <
ZBBottomIndexViewDelegate,
UISearchBarDelegate,
UITableViewDataSource,UITableViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) UITableView *filterTableView1;
@property (readwrite) UITableView *filterTableView2;
@property (readwrite) NSArray *filterClassifiesData;
@property (readwrite) NSArray *filterCirclesData;
@property (readwrite) NSArray *filterDistanceAndTimeData;
@property (readwrite) NSArray *distances;
@property (readwrite) MLStoreClassify *selectedClassfy;
@property (readwrite) MLCircle *selectedCircle;
@property (readwrite) NSNumber *selectedDistance;
@property (readwrite) NSInteger selectedFilterIndex;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) NSArray *stores;
@property (readwrite) MLSortType sortType;
@property (readwrite) NSInteger page;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLStoresSearchResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"商家";
	self.view.backgroundColor = [UIColor backgroundColor];
	_page = 1;
	
	_sectionClasses = @[[MLStoreCollectionViewCell class]];
	
	CGRect rect = CGRectZero;
	rect.origin.x = 0;
	rect.origin.y = 64;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 32;
	
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:rect];
	[_bottomIndexView setItems:@[@"全部分类", @"全城", @"距离优先"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	_bottomIndexView.hiddenIndexView = YES;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
	[self.view addSubview:_bottomIndexView];
	
	rect.origin.y = CGRectGetMaxY(_bottomIndexView.frame);
	if (!_classifyID) {
		
		rect.size.height = 34;
		_searchBar = [[UISearchBar alloc] initWithFrame:rect];
		_searchBar.delegate = self;
		[self.view addSubview:_searchBar];
		rect.origin.y = CGRectGetMaxY(_searchBar.frame);
	}
	rect.size.height = self.view.bounds.size.height - rect.origin.y;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumLineSpacing = 0;
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[self.view addSubview:_collectionView];
	for (Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
	
	_filterTableView1 = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_filterTableView1.dataSource = self;
	_filterTableView1.delegate = self;
	[self.view addSubview:_filterTableView1];
	
	rect.origin.x = self.view.bounds.size.width / 2;
	rect.size.width = self.view.bounds.size.width / 2;
	_filterTableView2 = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_filterTableView2.dataSource = self;
	_filterTableView2.delegate = self;
	_filterTableView2.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:_filterTableView2];
	
	_filterTableView1.hidden = YES;
	_filterTableView2.hidden = YES;
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoSearchResult"];
	_noDataView.label.text = @"未找到结果";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
	
	[[MLAPIClient shared] storeClassifiesWithBlock:^(NSArray *multiAttribues, MLResponse *response) {
		if (response.success) {
			_filterClassifiesData = [MLStoreClassify multiWithAttributesArray:multiAttribues];
			[_filterTableView1 reloadData];
		}
	}];
	
	[[MLAPIClient shared] storeCirclesWithBlock:^(NSArray *distances, NSArray *multiAttributtes, MLResponse *response) {
		if (response.success) {
			_distances = [NSArray arrayWithArray:distances];
			
#warning TODO:
			MLCircle *circle = [[MLCircle alloc] init];
			circle.ID = @"123123";
			circle.name = @"观前街";
			
			_filterCirclesData = @[circle];
			
			[_filterTableView1 reloadData];
			[_filterTableView2 reloadData];
		}
	}];
	
	[self fetchStores];
}

- (void)fetchStores {
	[[MLAPIClient shared] searchStoresWithCityID:_city.ID classifyID:_classifyID circleID:_selectedCircle.ID distance:_selectedDistance keyword:_searchString sort:_sortType page:@(_page) withBlock:^(NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_stores = [MLStore multiWithAttributesArray:multiAttributes];
			_noDataView.hidden = _stores.count ? YES : NO;
			[_collectionView reloadData];
		}
	}];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
	_filterTableView1.hidden = NO;
	_filterTableView2.hidden = YES;
	[_filterTableView1 reloadData];
	[_filterTableView2 reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	CGFloat height = [class height];
	CGFloat width = collectionView.bounds.size.width;
	return CGSizeMake(width, height);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
//	if (!_headerLabel) {
//		_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(minimumInteritemSpacing, 0, collectionView.bounds.size.width - 2 * minimumInteritemSpacing, view.bounds.size.height)];
//		_headerLabel.text = NSLocalizedString(@"会员精选", nil);
//		_headerLabel.textColor = [UIColor lightGrayColor];
//		[view addSubview:_headerLabel];
//	}
//	return view;
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
//	Class class = _sectionClasses[section];
//	if (class == [MLStoreCollectionViewCell class]) {
//		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 46);
//	} else {
//		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 10);
//	}
	return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _stores.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	if (class == [MLStoreCollectionViewCell class]) {
		MLStoreCollectionViewCell *storeCell = (MLStoreCollectionViewCell *)cell;
		storeCell.store = _stores[indexPath.row];
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLStoreCollectionViewCell class]) {
		MLStore *store = _stores[indexPath.row];
		MLStoreDetailsViewController *storeDetailsViewController = [[MLStoreDetailsViewController alloc] initWithNibName:nil bundle:nil];
		storeDetailsViewController.store = store;
        [storeDetailsViewController setLeftBarButtonItemAsBackArrowButton];
		[self.navigationController pushViewController:storeDetailsViewController animated:YES];
	}
}

#pragma mark - UITableVewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_bottomIndexView.selectedIndex == 0) {
		if (tableView == _filterTableView1) {
			return _filterClassifiesData.count + 1;
		} else {
			return _selectedClassfy.subClassifies.count + 1;
		}
	} else if (_bottomIndexView.selectedIndex == 1) {
		if (tableView == _filterTableView1) {
			return _filterCirclesData.count + 1;
		} else {
			return _distances.count;
		}
	}
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	}
	if (tableView == _filterTableView2) {
		cell.backgroundColor = [UIColor lightGrayColor];
	}
	if (_bottomIndexView.selectedIndex == 0) {
		if (tableView == _filterTableView1) {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"全部";
			} else {
				MLStoreClassify *classify = _filterClassifiesData[indexPath.row - 1];
				cell.textLabel.text = classify.name;
			}
		} else {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"全部";
			} else {
				MLStoreClassify *subClassify = _selectedClassfy.subClassifies[indexPath.row - 1];
				cell.textLabel.text = subClassify.name;
			}
		}
	} else if (_bottomIndexView.selectedIndex == 1) {
		if (tableView == _filterTableView1) {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"全部";
			} else {
				MLCircle *circle = _filterCirclesData[indexPath.row - 1];
				cell.textLabel.text = circle.name;
			}
		} else {
			NSNumber *dis = _distances[indexPath.row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@km", dis];
		}
	} else {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"距离优先";
		} else {
			cell.textLabel.text = @"最新发布";
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_bottomIndexView.selectedIndex == 0) {
		if (tableView == _filterTableView1) {
			if (indexPath.row == 0) {
				_filterTableView1.hidden = YES;
				_filterTableView2.hidden = YES;
				_selectedClassfy = nil;
			} else {
				_selectedClassfy = _filterClassifiesData[indexPath.row - 1];
				_filterTableView2.hidden = NO;
				[_filterTableView2 reloadData];
			}
		} else {
			_filterTableView1.hidden = YES;
			_filterTableView2.hidden = YES;
			[self fetchStores];
		}
	} else if (_bottomIndexView.selectedIndex == 1) {
		if (tableView == _filterTableView1) {
			if (indexPath.row == 0) {
				_selectedCircle = nil;
				_filterTableView2.hidden = NO;
				[_filterTableView2 reloadData];
			} else {
				_selectedCircle = _filterCirclesData[indexPath.row - 1];
				_filterTableView1.hidden = YES;
				_filterTableView2.hidden = YES;
			}
		} else {
			_selectedDistance = _distances[indexPath.row];
			_filterTableView1.hidden = YES;
			_filterTableView2.hidden = YES;
			[self fetchStores];
		}
	} else {
		if (tableView == _filterTableView1) {
			if (indexPath.row == 0) {
				_sortType = MLSortTypeDistance;
			} else {
				_sortType = MLSortTypeTime;
			}
			_filterTableView1.hidden = YES;
			_filterTableView2.hidden = YES;
			[self fetchStores];
		}
	}
}

@end
