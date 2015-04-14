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

@interface MLMainViewController () <
UISearchBarDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MLCollectionViewCellDelegate, UISearchBarDelegate>

@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) BOOL isSmallStyle;
@property (readwrite) NSArray *advertisements;
@property (readwrite) MLLoadingView *loadingView;

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
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	[self.view addSubview:_loadingView];
	[_loadingView start];
	
    [self addPullDownRefresh];
    
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
//    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    [self.collectionView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchMainData)];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:@"refresh_bg"];
        [refreshingImages addObject:image];
    }
    [self.collectionView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateIdle];
    self.collectionView.header.stateHidden = YES;
    self.collectionView.header.updatedTimeHidden = YES;
//    [self.collectionView  addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf fetchMainData];
//    }];
}

//获取首页数据
- (void)fetchMainData {
    __weak typeof(self) weakSelf = self;
    [[MLAPIClient shared] advertisementsInStores:NO withBlock:^(NSString *style, NSArray *multiAttributes, MLResponse *response) {
        _loadingView.hidden = YES;
        [self displayResponseMessage:response];
        if (response.success) {
            // 结束刷新
            [weakSelf.collectionView.header endRefreshing];
            if ([style.uppercaseString isEqualToString:@"T2"]) {
                _isSmallStyle = YES;
            }
            _advertisements = [MLAdvertisement multiWithAttributesArray:multiAttributes];
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.hidesBottomBarWhenPushed = YES;
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
			if (class == [MLGoodsDetailsViewController class]) {
				MLGoods *goods = [[MLGoods alloc] init];
				goods.ID = advertisementElement.parameterID;
				MLGoodsDetailsViewController *c = (MLGoodsDetailsViewController *)controller;
				c.goods = goods;
			} else if (class == [MLStoreDetailsViewController class]) {
				MLStore *store = [[MLStore alloc] init];
				store.ID = advertisementElement.parameterID;
				MLStoreDetailsViewController *c = (MLStoreDetailsViewController *)controller;
				c.store = store;
			} else if (class == [MLSearchResultViewController class]) {
				MLGoodsClassify *goodsClassify = [[MLGoodsClassify alloc] init];
				goodsClassify.ID = advertisementElement.parameterID;
				MLSearchResultViewController *c = (MLSearchResultViewController *)controller;
				c.goodsClassify = goodsClassify;
			} else if (class == [MLFlagshipStoreViewController class]) {
				MLFlagshipStore *flagshipStore = [[MLFlagshipStore alloc] init];
				flagshipStore.ID = advertisementElement.parameterID;
				MLFlagshipStoreViewController *c = (MLFlagshipStoreViewController *)controller;
				c.flagshipStore = flagshipStore;
			}
			controller.hidesBottomBarWhenPushed = YES;
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
	cell.backgroundColor = [UIColor whiteColor];
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
