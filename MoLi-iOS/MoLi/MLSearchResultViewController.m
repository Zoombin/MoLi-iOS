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
#import "MLFilterView.h"
#import "CDRTranslucentSideBar.h"
#import "MLFlagshipStore.h"
#import "MLFlagshipStoreViewController.h"
#import "MLBackToTopView.h"
#import "MLPagingView.h"
#import "MLNoDataView.h"

static CGFloat const heightOfFlagshipStoreHeight = 60;
static CGFloat const heightOfNavigationBar = 64;

@interface MLSearchResultViewController () <
ZBBottomIndexViewDelegate,
UISearchBarDelegate,
UICollectionViewDataSource, UICollectionViewDelegate,
MLFilterViewDelegate,
CDRTranslucentSideBarDelegate,
MLBackToTopViewDelegate
>

@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property (readwrite) UICollectionView *collectionView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) NSMutableArray *multiGoods;
@property (assign,nonatomic) NSInteger selectKind;//当前选择的排序
@property (readwrite) NSMutableArray *pricelistArr;//价格区间筛选条件
@property (readwrite) NSMutableArray *speclistArr;//规格筛选条件
@property (readwrite) NSArray *filters;
@property (readwrite) NSInteger page;
@property (readwrite) NSInteger maxPage;
@property (readwrite) BOOL noMore;
@property (readwrite) CGRect originRectOfBottomIndexView;
@property (readwrite) CGRect originRectOfCollectionView;
@property (readwrite) MLFilterView *filterview;
@property (readwrite) BOOL ishiden;
@property (readwrite) BOOL isaddMore;//是否加载更多
@property (readwrite) BOOL addModel;
@property (readwrite) int stockflag;
@property (readwrite) int voucherflag;
@property (readwrite) UIView *viewBG;
@property (readwrite) BOOL priceOrder;
@property (readwrite) MLFlagshipStore *flagshipStore;
@property (readwrite) UIImageView *flagshipStoreImageView;
@property (readwrite) CGRect originRectOfFlagshipStoreImageView;
@property (readwrite) MLBackToTopView *backToTopView;
@property (readwrite) MLPagingView *pagingView;
@property (readwrite) UIView *shadowView;
@property (readwrite) NSString *searchprices;
@property (readwrite) NSString *searchspec;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLSearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	if (_popToRoot) {
		[self setLeftBarButtonItemAsBackToRootArrowButton];
	} else {
		[self setLeftBarButtonItemAsBackArrowButton];
	}
	
	_page = 1;
    _voucherflag = 0;
    _stockflag = 0;
    _isaddMore = YES;
	_multiGoods = [NSMutableArray array];
    _pricelistArr = [NSMutableArray array];
    _speclistArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
       [_multiGoods addObject:[NSMutableArray array]];
    }
	_sectionClasses = @[[MLGoodsNormalCollectionViewCell class]];

	CGRect rect = CGRectZero;
	rect.origin.y = heightOfNavigationBar;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 0;
	_originRectOfFlagshipStoreImageView = rect;
	_flagshipStoreImageView = [[UIImageView alloc] initWithFrame:rect];
	_flagshipStoreImageView.backgroundColor = [UIColor redColor];
	[self.view addSubview:_flagshipStoreImageView];
	
	rect.origin.y = CGRectGetMaxY(_flagshipStoreImageView.frame);
	rect.size.height = 44;
	_originRectOfBottomIndexView = rect;
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:rect];
	[_bottomIndexView setItems:@[@"匹配度", @"价格", @"销量", @"好评率"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
    [_bottomIndexView setImages:[UIImage imageNamed:@"价格默认"]];
	_bottomIndexView.hidden = YES;
	[self.view addSubview:_bottomIndexView];
    
	
	rect.origin.y = CGRectGetMaxY(_bottomIndexView.frame);
	rect.size.height = self.view.bounds.size.height - rect.origin.y;
	_originRectOfCollectionView = rect;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	[_collectionView registerClass:[MLNoMoreDataFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[MLNoMoreDataFooter identifier]];
	[_collectionView registerClass:[MLGoodsNormalCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsNormalCollectionViewCell identifier]];
	[_collectionView registerClass:[MLGoodsCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsCollectionViewCell identifier]];
	[self.view addSubview:_collectionView];
	
	_filters = @[@"time", @"price", @"salesvolume", @"hignopinion"];
	
    _selectKind = 0;
	[self searchOrderby:_filters[0] keyword:_searchString price:nil spec:nil];
	[self displayStyleList];
	
    _filterview = [[MLFilterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-55, CGRectGetHeight(self.view.frame))];
    _filterview.delegate = self;
	
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.tag = 1;
    
    _shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
	[self.rightSideBar setContentViewInSideBar:_filterview];
	
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
	[self.view addSubview:_pagingView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoSearchResult"];
	_noDataView.label.text = @"未搜索到结果";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.delegate = self;
	if (_searchString) {
		_searchBar.text = _searchString;
	} else {
		_searchBar.text = _goodsClassify.name;
	}
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

#pragma mark MLFilterViewDelegate

- (void)filterViewattentionAlartMsg:(NSString *)msg{
    [self.rightSideBar displayHUDTitle:@"" message:msg duration:1];
}

- (void)filterViewRequestPramDictionary:(NSMutableDictionary *)dicpram {
    [self.rightSideBar dismissAnimated:YES];
    NSString *orderby = _filters[_bottomIndexView.selectedIndex];
    if (dicpram[@"voucherflag"]) {
        _voucherflag = [dicpram[@"voucherflag"] intValue];
    }else{
        _voucherflag = 0;
    }
    if (dicpram[@"stockflag"]) {
        _stockflag = [dicpram[@"stockflag"] intValue];
    }else{
        _stockflag = 0;
    }
    _isaddMore = NO;
    _noMore = NO;
    _searchprices = dicpram[@"price"];
    _searchspec = dicpram[@"spec"];
    _page = 1;
    [self searchOrderby:orderby keyword:_searchString price:dicpram[@"price"] spec:dicpram[@"spec"]];
}

- (void)filter {
    [self.rightSideBar show];
}

#pragma mark - CDRTranslucentSideBarDelegate

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated
{
    [self.view addSubview:_shadowView];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated
{
    [_shadowView removeFromSuperview];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated
{
}

-(void)ishidenFilterView:(CGRect)rect andHiden:(BOOL)flag {
    [UIView animateWithDuration:0.5 animations:^{
        [_filterview setFrame:rect];
        [_viewBG setHidden:flag];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)searchOrderby:(NSString *)orderby keyword:(NSString *)keyword price:(NSString*)pricestr spec:(NSString*)specstr {
	if (_noMore) return;
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
    [[MLAPIClient shared] searchGoodsWithClassifyID:_goodsClassify.ID keywords:keyword price:pricestr spec:specstr orderby:orderby ascended:_priceOrder stockflag:_stockflag voucherflag:_voucherflag page:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error, NSDictionary *attributes) {
		[self hideHUD:YES];
		if (!error) {
			if (_page <= 1) {//第一次请求时候判断是否有旗舰店信息
				_maxPage = [[attributes[@"totalpage"] notNull] integerValue];
				
				NSArray *flagshipStores = [attributes[@"storelist"] notNull];
				if (flagshipStores.count) {
					NSDictionary *flagshipStoreAttributes = flagshipStores[0];
					_flagshipStore = [[MLFlagshipStore alloc] initWithAttributes:flagshipStoreAttributes];
					[_flagshipStoreImageView setImageWithURL:[NSURL URLWithString:_flagshipStore.imagePath]];
					_originRectOfFlagshipStoreImageView.size.height = heightOfFlagshipStoreHeight;
					_flagshipStoreImageView.frame = _originRectOfFlagshipStoreImageView;
					UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedFlagshipStore)];
					_flagshipStoreImageView.userInteractionEnabled = YES;
					[_flagshipStoreImageView addGestureRecognizer:tap];
					
					CGRect rect2 = _originRectOfBottomIndexView;
					rect2.origin.y += _flagshipStoreImageView.bounds.size.height;
					_originRectOfBottomIndexView = rect2;
					_bottomIndexView.frame = _originRectOfBottomIndexView;
					
					CGRect rect3 = _originRectOfCollectionView;
					rect3.origin.y += _flagshipStoreImageView.bounds.size.height;
					rect3.size.height -= _flagshipStoreImageView.bounds.size.height;
					_originRectOfCollectionView = rect3;
					_collectionView.frame = _originRectOfCollectionView;
				}
			}
			
			if (_page < _maxPage + 1) {
				_page++;
			} else {
				_noMore = YES;
			}
			_bottomIndexView.hidden = NO;
			NSArray *array = [MLGoods multiWithAttributesArray:multiAttributes];
            //判断是否需要清空数组里的数据
            if (!_isaddMore) {
				[self removeArrayData];
            }
			
			[self addArrayData:array selectIndex:_selectKind];
			_noDataView.hidden = [self noneResult] ? NO : YES;
            
            [_pricelistArr addObjectsFromArray:attributes[@"pricelist"]];
            [_speclistArr addObjectsFromArray:attributes[@"speclist"]];
            
            if ([_speclistArr count] && [_pricelistArr count]) {
                if (!_addModel) {
                    _addModel = YES;
                    [_filterview loadModel:_speclistArr Price:_pricelistArr];
                }
            }
			[_collectionView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.localizedDescription];
		}
	}];
}

- (BOOL)noneResult {
	BOOL none = YES;
	for (int i = 0; i < _multiGoods.count; i++) {
		NSArray *array = _multiGoods[i];
		if (array.count) {
			none = NO;
			break;
		}
	}
	return none;
}

- (void)clickedFlagshipStore {
	if (_flagshipStore) {
		MLFlagshipStoreViewController *flagshipStoreViewController = [[MLFlagshipStoreViewController alloc] initWithNibName:nil bundle:nil];
		flagshipStoreViewController.flagshipStore = _flagshipStore;
		[self.navigationController pushViewController:flagshipStoreViewController animated:YES];
	}
}

-(void)removeArrayData{
    for (NSMutableArray*arr in _multiGoods) {
        [arr removeAllObjects];
    }

}


-(void)addArrayData:(NSArray*)array selectIndex:(NSInteger)selectIndex {
    [_multiGoods[selectIndex] addObjectsFromArray:array];
}

- (void)showNavigationBarFlagshipStoreAndBottomIndexView {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	CGRect rect = _originRectOfFlagshipStoreImageView;
	CGRect rect2 = _originRectOfBottomIndexView;
	CGRect rect3 = _originRectOfCollectionView;
	[UIView animateWithDuration:0.25 animations:^{
		_flagshipStoreImageView.frame = rect;
		_bottomIndexView.frame = rect2;
		_collectionView.frame = rect3;
	}];
}

- (void)hideNavigationBarFlagshipStoreAndBottomIndexView {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	CGRect rect = _originRectOfFlagshipStoreImageView;
	CGRect rect2 = _originRectOfBottomIndexView;
	CGRect rect3 = _originRectOfCollectionView;
	
	rect.origin.y = rect.origin.y - heightOfNavigationBar - _flagshipStoreImageView.bounds.size.height;
	rect2.origin.y = rect2.origin.y - heightOfNavigationBar - _flagshipStoreImageView.bounds.size.height - _bottomIndexView.bounds.size.height;
	rect3.origin.y = rect3.origin.y - heightOfNavigationBar - _flagshipStoreImageView.bounds.size.height - _bottomIndexView.bounds.size.height;
	rect3.size.height += heightOfNavigationBar + _flagshipStoreImageView.bounds.size.height + _bottomIndexView.bounds.size.height;
	
	[UIView animateWithDuration:0.25 animations:^{
		_flagshipStoreImageView.frame = rect;
		_bottomIndexView.frame = rect2;
		_collectionView.frame = rect3;
	}];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height) {
		NSString *orderby = _filters[_bottomIndexView.selectedIndex];
        _isaddMore = YES;
        [self searchOrderby:orderby keyword:_searchString price:_searchprices?_searchprices:nil spec:_searchspec?_searchspec:nil];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_searchBar resignFirstResponder];
	CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
	if(translation.y > 0) {//显示
		if (self.navigationController.navigationBar.hidden) {
			[self showNavigationBarFlagshipStoreAndBottomIndexView];
		}
	} else {//隐藏
		if (!self.navigationController.navigationBar.hidden) {
			[self hideNavigationBarFlagshipStoreAndBottomIndexView];
		}
		[_pagingView updateMaxPage:_maxPage currentPage:_page - 1];
		if (scrollView.contentOffset.y <= 40) {
			_backToTopView.hidden = YES;
		} else {
			_backToTopView.hidden = NO;
		}
	}
}


#pragma mark - Gesture Handler

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
//            self.sideBar.isCurrentPanGestureTarget = YES;
        }
        // Right SideBar
        else {
            self.rightSideBar.isCurrentPanGestureTarget = YES;
        }
    }
    [self.rightSideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[_searchBar resignFirstResponder];
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.searchString = _searchString;
	searchViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
    _selectKind = selectedIndex;
	if (selectedIndex <= _filters.count) {
		NSString *orderby = _filters[selectedIndex];
        if (selectedIndex == 1) {
            if (_priceOrder) {
                _priceOrder = NO;
                [_bottomIndexView setImages:[UIImage imageNamed:@"价格"]];
            }else{
                _priceOrder = YES;
                [_bottomIndexView setImages:[UIImage imageNamed:@"价格默认"]];
            }
        }
        _page = 1;
		[self searchOrderby:orderby keyword:_searchString price:_searchprices?_searchprices:nil spec:_searchspec?_searchspec:nil];
	}
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (_noMore && ![self noneResult]) {
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
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
	flowLayout.minimumLineSpacing = 0;
	if (class == [MLGoodsCollectionViewCell class]) {
		flowLayout.minimumLineSpacing = 10;
		NSInteger numberPerLine = 2;
		CGFloat itemWidth = [class size].width;
		CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
		return UIEdgeInsetsMake(0, gap, 0, gap);
	}
	return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_multiGoods[_selectKind] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	MLGoods *goods = _multiGoods[_selectKind][indexPath.row];
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
	MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
	goodsDetailsViewController.goods = _multiGoods[_selectKind][indexPath.row];
	goodsDetailsViewController.previousViewControllerHidenBottomBar = YES;
	[self.navigationController pushViewController:goodsDetailsViewController animated:YES];
}

#pragma mark - MLBackToTopDelegate

- (void)willBackToTop {
	[_collectionView setContentOffset:CGPointZero animated:YES];
	[self performSelector:@selector(showNavigationBarFlagshipStoreAndBottomIndexView) withObject:nil afterDelay:0.4];
	_backToTopView.hidden = YES;
}

@end
