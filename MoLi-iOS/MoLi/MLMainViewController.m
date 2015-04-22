//
//  MLMainViewController.m
//  MoLi
//
//  Created by zhangbin on 11/17/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMainViewController.h"
#import "Header.h"
#import "MLCollectionViewCell.h"
#import "MLBannerCollectionViewCell.h"
#import "MLShortcutsCollectionViewCell.h"
#import "MLNormalCollectionViewCell.h"
#import "MLMemberCardViewController.h"
#import "MLVoucherViewController.h"
#import "MLPrivilegeViewController.h"
#import "MLFavoritesViewController.h"
#import "MLAdvertisement.h"
#import "MLAdvertisementElement.h"
#import "MLWebViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLStoreDetailsViewController.h"
#import "MLSearchResultViewController.h"
#import "MLQRCodeScanViewController.h"
#import "MLLoadingView.h"
#import "MLSearchViewController.h"
#import "MLFlagshipStoreViewController.h"
#import "MJRefresh.h"
#import "MLNoDataView.h"
#import "MLPrivilegeViewController.h"
#import "MLSigninViewController.h"

@interface MLMainViewController () <
UISearchBarDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MLCollectionViewCellDelegate, UISearchBarDelegate>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) BOOL isSmallStyle;
@property (readwrite) NSArray *advertisements;
@property (readwrite) MLLoadingView *loadingView;
@property (readwrite) MLNoDataView *badNetworkingView;

@end

@implementation MLMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"首页", nil);
		
		UIImage *normalImage = [[UIImage imageNamed:@"Main"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"MainHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage  selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
	
	_sectionClasses = @[[MLBannerCollectionViewCell class], [MLShortcutsCollectionViewCell class], [MLNormalCollectionViewCell class]];
	
	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
	[self.view addSubview:_collectionView];
	for (Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
    
    [_collectionView addMoLiHeadView];
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	//[self.view addSubview:_loadingView];
	//[_loadingView start];
	
//	_blankCartView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
//	_blankCartView.imageView.image = [UIImage imageNamed:@"BlankCart"];
//	_blankCartView.label.text = @"购物车还是空的\n去挑选几件中意的商品吧";
//	_blankCartView.button.hidden = NO;
//	[_blankCartView.button setTitle:@"开始购物" forState:UIControlStateNormal];
//	_blankCartView.hidden = YES;
//	[_blankCartView.button addTarget:self action:@selector(goToShopping) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:_blankCartView];
	
	_badNetworkingView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_badNetworkingView.imageView.image = [UIImage imageNamed:@"BadNetworking"];
    [_badNetworkingView.button setTitle:@"点击重新加载" forState:UIControlStateNormal];
	_badNetworkingView.label.text = @"网络不佳";
	_badNetworkingView.hidden = YES;
	_badNetworkingView.button.hidden = NO;
	_badNetworkingView.button.titleLabel.font = [UIFont systemFontOfSize:16];
    _badNetworkingView.delegate = self;
	[self.view addSubview:_badNetworkingView];
	
	[self addPullDownRefresh];
	
	NSArray *multiAttributes = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_KEY];
	if (multiAttributes) {
		_advertisements = [MLAdvertisement multiWithAttributesArray:multiAttributes];
	}
	
	NSString *style = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_STYLE];
	if ([style.uppercaseString isEqualToString:@"T2"]) {
		_isSmallStyle = YES;
	}
	[_collectionView reloadData];
	
    [self fetchMainData];
}

- (void)noDataViewReloadData {
    [self fetchMainData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.tabBarController.tabBar.hidden = NO;
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.searchBarStyle = UISearchBarIconBookmark;
	searchBar.delegate = self;
	searchBar.placeholder = @"搜索商品";
	[self.navigationItem setTitleView:searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scan {
	MLQRCodeScanViewController *QRCodeScanViewController = [[MLQRCodeScanViewController alloc] initWithNibName:nil bundle:nil];
	QRCodeScanViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:QRCodeScanViewController animated:YES];
}

- (void)gotoViewController:(Class)controllerClass {
	UIViewController *controller = [[controllerClass alloc] initWithNibName:nil bundle:nil];
    [controller setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:controller animated:YES];
}

// 添加下拉刷新功能
- (void)addPullDownRefresh {
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
#warning 这边之所以会无限刷新。。 是因为end也会调用这边的，所以要判断下header的state.
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        if (weakSelf.collectionView.header.state != MJRefreshFooterStateIdle) {
            [weakSelf fetchMainData];
        }
    }];
    
    self.collectionView.header.updatedTimeHidden = YES;
}

//获取首页数据
- (void)fetchMainData {
	[_collectionView.header beginRefreshing];
    __weak typeof(self) weakSelf = self;
    [[MLAPIClient shared] advertisementsInStores:NO withBlock:^(NSString *style, NSArray *multiAttributes, MLResponse *response, NSError *error) {
        _loadingView.hidden = YES;
        [self displayResponseMessage:response];
        if (response.success) {
			[[NSUserDefaults standardUserDefaults] setObject:multiAttributes forKey:ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_KEY];
			[[NSUserDefaults standardUserDefaults] setObject:style forKey:ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_STYLE];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			_collectionView.hidden = NO;
            // 结束刷新
            [weakSelf.collectionView.header endRefreshing];
            if ([style.uppercaseString isEqualToString:@"T2"]) {
                _isSmallStyle = YES;
            }
            _advertisements = [MLAdvertisement multiWithAttributesArray:multiAttributes];
            [_collectionView reloadData];
        }
		
		if (error && !_advertisements) {
			_badNetworkingView.hidden = NO;
			_collectionView.hidden = YES;
			[_collectionView.header endRefreshing];
		} else {
			_badNetworkingView.hidden = YES;
            [_collectionView.header endRefreshing];
		}
		
		if (error) {
			[self displayHUDTitle:nil message:error.localizedDescription];
		}
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.hidesBottomBarWhenPushed = YES;
	searchViewController.popTargetIsRoot = YES;
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - MLCollectionViewCellDelegate

- (void)collectionViewCellWillSelectAdvertisement:(MLAdvertisement *)advertisement advertisementElement:(MLAdvertisementElement *)advertisementElement {	
	if (advertisementElement) {
		if ([advertisementElement isOpenWebView]) {
			MLWebViewController *webViewController = [[MLWebViewController alloc] initWithNibName:nil bundle:nil];
			webViewController.URLString = advertisementElement.URLString;
			[self.navigationController pushViewController:webViewController animated:YES];
		} else {
			Class class = [advertisementElement classOfRedirect];
			UIViewController *controller = [[class alloc] initWithNibName:nil bundle:nil];
			controller.hidesBottomBarWhenPushed = YES;
			if (class == [MLGoodsDetailsViewController class]) {
				MLGoods *goods = [[MLGoods alloc] init];
				goods.ID = advertisementElement.parameterID;
				MLGoodsDetailsViewController *c = (MLGoodsDetailsViewController *)controller;
				c.goods = goods;
				c.hidesBottomBarWhenPushed = NO;
			} else if (class == [MLStoreDetailsViewController class]) {
				MLStore *store = [[MLStore alloc] init];
				store.ID = advertisementElement.parameterID;
				MLStoreDetailsViewController *c = (MLStoreDetailsViewController *)controller;
				c.store = store;
			} else if (class == [MLSearchResultViewController class]) {
				MLGoodsClassify *goodsClassify = [[MLGoodsClassify alloc] init];
				goodsClassify.ID = advertisementElement.parameterID;
				MLSearchResultViewController *c = (MLSearchResultViewController *)controller;
				c.popTargetIsRoot = YES;
				c.goodsClassify = goodsClassify;
			} else if (class == [MLFlagshipStoreViewController class]) {
				MLFlagshipStore *flagshipStore = [[MLFlagshipStore alloc] init];
				flagshipStore.ID = advertisementElement.parameterID;
				MLFlagshipStoreViewController *c = (MLFlagshipStoreViewController *)controller;
				c.flagshipStore = flagshipStore;
			} else if (class != [MLPrivilegeViewController class]) {
				if (![[MLAPIClient shared] sessionValid]) {
					MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
					[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
					return;
				}
			}
			[self.navigationController pushViewController:controller animated:YES];
		}
	}
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	CGFloat width = collectionView.bounds.size.width;
	CGFloat height = [class height];
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
	flowLayout.headerReferenceSize = CGSizeZero;
	if (class == [MLNormalCollectionViewCell class]) {
		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 40);
		if (_isSmallStyle) {
			return [class smallStyleSize];
		} else {
			return [class size];
		}
	}
	return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
	[view removeAllSubviews];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 0, collectionView.bounds.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, view.bounds.size.height)];
	label.text = @"会员精选";
	label.textColor = [UIColor fontGrayColor];
	label.font = [UIFont systemFontOfSize:16];
	[view addSubview:label];
	return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLNormalCollectionViewCell class]) {
			CGFloat itemWidth = [MLNormalCollectionViewCell smallStyleSize].width;
		NSInteger numberPerLine = 1;
		if (_isSmallStyle) {
			numberPerLine = 2;
		}
		CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
		return UIEdgeInsetsMake(0, gap, 0, gap);
	}
	return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == 2) {
		MLAdvertisement *advertisement = [MLAdvertisement advertisementOfType:MLAdvertisementTypeNormal inAdvertisements:_advertisements];
		return advertisement.elements.count;
	}
	return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	MLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	MLAdvertisement *advertisement = nil;
	MLAdvertisementElement *element = nil;
	
	if (class == [MLBannerCollectionViewCell class]) {
		advertisement = [MLAdvertisement advertisementOfType:MLAdvertisementTypeBanner inAdvertisements:_advertisements];
	} else if (class == [MLShortcutsCollectionViewCell class]) {
		advertisement = [MLAdvertisement advertisementOfType:MLAdvertisementTypeShortcut inAdvertisements:_advertisements];
	} else if (class == [MLNormalCollectionViewCell class]) {
		advertisement = [MLAdvertisement advertisementOfType:MLAdvertisementTypeNormal inAdvertisements:_advertisements];
		if (advertisement) {
			element = advertisement.elements[indexPath.row];
		}
	}
	
	cell.advertisement = advertisement;
	cell.advertisementElement = element;
	cell.delegate = self;
	return cell;
}



@end
