//
//  MLStoresViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoresViewController.h"
#import "Header.h"
#import "MLGoods.h"
#import "MLCity.h"
#import "MLStore.h"
#import "MLStoreCategoryTableViewCell.h"
#import "MLStoreDetailsViewController.h"
#import "MLSearchViewController.h"
#import "MLAdvertisement.h"
#import "MLShortcutsCollectionViewCell.h"
#import "MLHotStoresCollectionViewCell.h"
#import "MLStoreCollectionViewCell.h"
#import "MLWebViewController.h"
#import "MLStoresSearchResultViewController.h"
//#import "MLNearbyStoresListViewController.h"
#import "MLLoadingView.h"

@interface MLStoresViewController () <
MLCollectionViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UISearchBarDelegate
>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) MLCity *currentCity;
@property (readwrite) NSArray *cities;
@property (readwrite) NSArray *storesYouLike;
@property (readwrite) UIView *pickCityView;
@property (readwrite) NSArray *advertisements;
@property (readwrite) MLLoadingView *loadingView;

@end

@implementation MLStoresViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"实体店", nil);
		
		UIImage *normalImage = [[UIImage imageNamed:@"Stores"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"StoresHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"LocationBig"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(location)];
	
	_sectionClasses = @[[MLShortcutsCollectionViewCell class], [MLHotStoresCollectionViewCell class], [MLStoreCollectionViewCell class]];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumLineSpacing = 0;
	_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
	[self.view addSubview:_collectionView];
	for (Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}

	
	_pickCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
	_pickCityView.backgroundColor = [UIColor whiteColor];
	_pickCityView.hidden = YES;
	[self.view addSubview:_pickCityView];
	
	CGRect rect = CGRectZero;
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	[self.view addSubview:_loadingView];
	[_loadingView start];
	
	[[MLAPIClient shared] advertisementsInStores:YES withBlock:^(NSString *style, NSArray *multiAttributes, MLResponse *response) {
		_loadingView.hidden = YES;
		if (response.success) {
			_advertisements = [MLAdvertisement multiWithAttributesArray:multiAttributes];
			[_collectionView reloadData];
		}
	}];
	
	[[MLAPIClient shared] citiesWithBlock:^(NSDictionary *attributes, NSArray *multiAttributes, NSError *error) {
		if (!error) {
			_currentCity = [[MLCity alloc] initWithAttributes:attributes];
			_cities = [MLCity multiWithAttributesArray:multiAttributes];
			NSLog(@"cities: %@", _cities);
			
			[self addLeftBarButtonItem];
			
			CGRect rect = _pickCityView.frame;
			rect.size.height = _cities.count * 30;
			_pickCityView.frame = rect;
			
			for (int i = 0; i < _cities.count; i++) {
				MLCity *city = _cities[i];
				UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
				button.layer.borderWidth = 0.5;
				button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
				[button setTitle:city.name forState:UIControlStateNormal];
				[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				button.frame = CGRectMake(0, 30 * i, _pickCityView.frame.size.width, 30);
				[button addTarget:self action:@selector(selectedCity:) forControlEvents:UIControlEventTouchUpInside];
				button.tag = i;
				[_pickCityView addSubview:button];
			}
			
			//猜你喜欢
			[[MLAPIClient shared] storesWithCityID:_currentCity.ID hot:NO withBlock:^(NSArray *multiAttributes, NSError *error) {
				[self hideHUD:YES];
				if (!error) {
					_storesYouLike = [MLStore multiWithAttributesArray:multiAttributes];
					[_collectionView reloadData];
				}
			}];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.delegate = self;
	searchBar.placeholder = @"输入商家、分类或商圈";
	searchBar.searchBarStyle = UISearchBarIconBookmark;
	self.navigationItem.titleView = searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addLeftBarButtonItem {
	if (_cities.count) {
		NSString *cityName = @"未知";
		if (_currentCity) {
			cityName = _currentCity.name;
		}
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cityName style:UIBarButtonItemStylePlain target:self action:@selector(pickCity)];
	}
}

- (void)pushToStoreDetails:(MLStore *)store {
	MLStoreDetailsViewController *storeDetailsViewController = [[MLStoreDetailsViewController alloc] initWithNibName:nil bundle:nil];
	storeDetailsViewController.hidesBottomBarWhenPushed = YES;
	storeDetailsViewController.store = store;
    storeDetailsViewController.city = _currentCity;
    [storeDetailsViewController setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:storeDetailsViewController animated:YES];
}

- (void)selectedCity:(UIButton *)sender {
	_currentCity = _cities[sender.tag];
	[self addLeftBarButtonItem];
	_pickCityView.hidden = YES;
}

- (void)location {
#warning TODO
//    MLNearbyStoresListViewController *nearByController = [MLNearbyStoresListViewController new];
//    nearByController.cityId = [NSString stringWithFormat:@"%@", _currentCity.ID];
//    [self.navigationController pushViewController:nearByController animated:YES];
}

- (void)pickCity {
//	_pickCityView.hidden = NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.isSearchStores = YES;
	searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - MLStoreHotTabelViewCellDelegate

- (void)storeHotTableViewCellTappedStore:(MLStore *)store {
	[self pushToStoreDetails:store];
}

#pragma mark - MLCollectionViewCellDelegate

- (void)collectionViewCellWillSelectAdvertisement:(MLAdvertisement *)advertisement advertisementElement:(MLAdvertisementElement *)advertisementElement {
	if (advertisementElement) {
		if ([advertisementElement isOpenWebView]) {
			MLWebViewController *webViewController = [[MLWebViewController alloc] initWithNibName:nil bundle:nil];
			webViewController.URLString = advertisementElement.URLString;
            [webViewController setLeftBarButtonItemAsBackArrowButton];
			[self.navigationController pushViewController:webViewController animated:YES];
		} else {
			Class class = [advertisementElement classOfRedirect];
			UIViewController *controller = [[class alloc] initWithNibName:nil bundle:nil];
			if (class == [MLStoresSearchResultViewController class]) {
				MLStoresSearchResultViewController *storesSearchResultViewController = (MLStoresSearchResultViewController *)controller;
				storesSearchResultViewController.hidesBottomBarWhenPushed = YES;
				storesSearchResultViewController.classifyID = advertisementElement.parameterID;
				storesSearchResultViewController.city = _currentCity;
			}
            [controller setLeftBarButtonItemAsBackArrowButton];
			[self.navigationController pushViewController:controller animated:YES];
		}
	}
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
	flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 10);
	flowLayout.footerReferenceSize = CGSizeZero;
	if (class == [MLHotStoresCollectionViewCell	class]) {
		flowLayout.footerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 10);
	} else if (class == [MLStoreCollectionViewCell class]) {
		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 36);
	}
  	CGFloat height = [class height];
	return CGSizeMake(collectionView.bounds.size.width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	NSString *identifier = @"Header";
	if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
		identifier = @"Footer";
	}
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
	[view removeAllSubviews];
	view.backgroundColor = [UIColor clearColor];
	if (class == [MLStoreCollectionViewCell class] && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
		view.backgroundColor = [UIColor whiteColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 0, collectionView.bounds.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, view.bounds.size.height)];
		label.text = @"猜你喜欢";
		label.textColor = [UIColor fontGrayColor];
		label.font = [UIFont systemFontOfSize:15];
		
		[view addSubview:[UIView borderLineWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, view.bounds.size.height - 0.5, collectionView.bounds.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, 0.5)]];
		[view addSubview:label];
	}
	return view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLStoreCollectionViewCell class]) {
		return _storesYouLike.count;
	}
	return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	if (class == [MLStoreCollectionViewCell class]) {
		MLStoreCollectionViewCell *storeCell = (MLStoreCollectionViewCell *)cell;
		storeCell.store = _storesYouLike[indexPath.row];
	} else {
		MLCollectionViewCell *mlCell = (MLCollectionViewCell *)cell;
		cell.backgroundColor = [UIColor whiteColor];
		MLAdvertisement *advertisement = nil;
		MLAdvertisementElement *element = nil;
		
		if (class == [MLShortcutsCollectionViewCell class]) {
			advertisement = [MLAdvertisement advertisementOfType:MLAdvertisementTypeShortcut inAdvertisements:_advertisements];
		} else if (class == [MLHotStoresCollectionViewCell class]) {
			NSArray *ads = [MLAdvertisement severalAdvertisementsOfType:MLAdvertisementTypeHot inAdvertisements:_advertisements];
			MLHotStoresCollectionViewCell *hotCell = (MLHotStoresCollectionViewCell *)cell;
			hotCell.advertisements = ads;
		}
		
		mlCell.advertisement = advertisement;
		mlCell.advertisementElement = element;
		mlCell.delegate = self;
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLStoreCollectionViewCell class]) {
		MLStore *store = _storesYouLike[indexPath.row];
		[self pushToStoreDetails:store];
	}
}


@end
