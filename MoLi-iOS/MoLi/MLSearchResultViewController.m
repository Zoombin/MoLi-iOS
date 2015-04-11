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
#import "MLFilterView.h"
#import "CDRTranslucentSideBar.h"
#import "MLFlagshipStore.h"
#import "MLFlagshipStoreViewController.h"

static CGFloat const heightOfFlagshipStoreHeight = 60;
static CGFloat const heightOfNavigationBar = 64;

@interface MLSearchResultViewController () <
ZBBottomIndexViewDelegate,
UISearchBarDelegate,
UICollectionViewDataSource, UICollectionViewDelegate,MLFilterViewDelegate,CDRTranslucentSideBarDelegate
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
@property (readwrite) BOOL noMore;
@property (readwrite) CGRect originRectOfBottomIndexView;
@property (readwrite) CGRect originRectOfCollectionView;
@property (readwrite) MLFilterView *filterview;
@property (readwrite) BOOL ishiden;
@property (readwrite) BOOL addModel;
@property (readwrite) UIView *viewBG;
@property (readwrite) BOOL priceOrder;
@property (readwrite) MLFlagshipStore *flagshipStore;
@property (readwrite) UIImageView *flagshipStoreImageView;
@property (readwrite) CGRect originRectOfFlagshipStoreImageView;

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
	self.view.backgroundColor = [UIColor whiteColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	_page = 1;
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
//	[_flagshipStoreImageView setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"]];
	[self.view addSubview:_flagshipStoreImageView];
	
	rect.origin.y = CGRectGetMaxY(_flagshipStoreImageView.frame);
	rect.size.height = 34;
	_originRectOfBottomIndexView = rect;
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:rect];
	[_bottomIndexView setItems:@[@"最新", @"价格", @"销量", @"好评率"]];
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
//	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
	[_collectionView registerClass:[MLGoodsNormalCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsNormalCollectionViewCell identifier]];
	[_collectionView registerClass:[MLGoodsCollectionViewCell class] forCellWithReuseIdentifier:[MLGoodsCollectionViewCell identifier]];
	[self.view addSubview:_collectionView];
	
	_filters = @[@"time", @"price", @"salesvolume", @"hignopinion"];
	
	if (_searchString) {
		_searchBar.text = _searchString;
	} else {
		_searchBar.text = _goodsClassify.name;
	}
    _selectKind = 0;
	[self searchOrderby:_filters[0] keyword:_searchString price:nil spec:nil];
	[self displayStyleList];
    
    _viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [_viewBG setBackgroundColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:0.5]];
    [self.view addSubview:_viewBG];
    _viewBG.hidden = YES;
   
    _filterview = [[MLFilterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-55, CGRectGetHeight(self.view.frame))];
    _filterview.delegate = self;
	
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.tag = 1;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
     [self.rightSideBar setContentViewInSideBar:_filterview];
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

#pragma mark MLFilterViewDelegate
-(void)filterViewattentionAlartMsg:(NSString *)msg{
    [self.rightSideBar displayHUDTitle:@"" message:msg duration:1];

}

-(void)filterViewRequestPramDictionary:(NSMutableDictionary *)dicpram{
    [self.rightSideBar dismissAnimated:YES];
    NSString *orderby = _filters[_bottomIndexView.selectedIndex];
    [self searchOrderby:orderby keyword:self.searchString price:dicpram[@"price"] spec:dicpram[@"spec"]];

}

- (void)filter {
    [self.rightSideBar show];
}


#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated
{
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated
{
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
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	[[MLAPIClient shared] searchGoodsWithClassifyID:_goodsClassify.ID keywords:keyword price:pricestr spec:specstr orderby:orderby ascended:_priceOrder page:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error,NSDictionary *attributes) {
		[self hideHUD:YES];
		if (!error) {
			if (_page == 1) {//第一次请求时候判断是否有旗舰店信息
				NSArray *flagshipStores = attributes[@"storelist"];
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
			
			_page++;
			_bottomIndexView.hidden = NO;
			
			NSArray *array = [MLGoods multiWithAttributesArray:multiAttributes];
            [self addArrayData:array selectIndex:_selectKind];
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
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

- (void)clickedFlagshipStore {
	if (_flagshipStore) {
		MLFlagshipStoreViewController *flagshipStoreViewController = [[MLFlagshipStoreViewController alloc] initWithNibName:nil bundle:nil];
		flagshipStoreViewController.flagshipStore = _flagshipStore;
		[self.navigationController pushViewController:flagshipStoreViewController animated:YES];
	}
}

-(void)addArrayData:(NSArray*)array selectIndex:(NSInteger)selectIndex {
    [_multiGoods[selectIndex] addObjectsFromArray:array];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height) {
		NSString *orderby = _filters[_bottomIndexView.selectedIndex];
		[self searchOrderby:orderby keyword:nil price:nil spec:nil];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_searchBar resignFirstResponder];
	CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
	if(translation.y > 0) {//显示
		if (self.navigationController.navigationBar.hidden) {
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
	} else {//隐藏
		if (!self.navigationController.navigationBar.hidden) {
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
	searchViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
    _selectKind = selectedIndex;
	if (selectedIndex <= _filters.count) {
		NSString *orderby = _filters[selectedIndex];
        if (selectedIndex==1) {
            if (_priceOrder) {
                _priceOrder = NO;
                [_bottomIndexView setImages:[UIImage imageNamed:@"价格"]];
            }else{
                _priceOrder = YES;
                [_bottomIndexView setImages:[UIImage imageNamed:@"价格默认"]];
            }
        }
		[self searchOrderby:orderby keyword:self.searchString price:nil spec:nil];
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
	MLGoodsPropertiesPickerViewController *goodsPropertiesPickerViewController = [[MLGoodsPropertiesPickerViewController alloc] initWithNibName:nil bundle:nil];
	goodsPropertiesPickerViewController.hidesBottomBarWhenPushed = YES;
	MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
	goodsDetailsViewController.propertiesPickerViewController = goodsPropertiesPickerViewController;

	goodsDetailsViewController.goods = _multiGoods[_selectKind][indexPath.row];
	
	IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:goodsDetailsViewController rightViewController:goodsPropertiesPickerViewController];
	deckController.rightSize = [MLGoodsPropertiesPickerViewController indent];
	[self.navigationController pushViewController:deckController animated:YES];
}

@end
