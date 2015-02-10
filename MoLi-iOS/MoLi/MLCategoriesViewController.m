//
//  MLCategoriesViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLCategoriesViewController.h"
#import "Header.h"
#import "MLGoodsClassify.h"
#import "MLSearchViewController.h"
#import "MLSearchResultViewController.h"
#import "MLLoadingView.h"

@interface MLCategoriesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (readwrite) UISearchBar *searchBar;
@property (readwrite) NSArray *goodsClassifies;
@property (readwrite) UITableView *firstClassifyTableView;
@property (readwrite) UITableView *secondClassifyTableView;
@property (readwrite) UITableView *thirdClassifyTableView;
@property (readwrite) NSIndexPath *indexPathSelectedInFirstClassify;
@property (readwrite) NSIndexPath *indexPathSelectedInSecondClassify;
@property (readwrite) UIColor *colorOfFirstClassify;
@property (readwrite) UIColor *colorOfSecondClassify;
@property (readwrite) UIColor *colorOfthirdClassify;
@property (readwrite) MLLoadingView *loadingView;
@property (readwrite) UIImageView *arrowIndexLightGray;
@property (readwrite) UIImageView *arrowIndexGray;
@property (readwrite) CGFloat secondTableViewStartX;
@property (readwrite) CGFloat thirdTableViewStartX;
@property (readwrite) BOOL thirdTableViewHidden;

@end

@implementation MLCategoriesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"分类", nil);
		
		UIImage *normalImage = [[UIImage imageNamed:@"Categories"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"CategoriesHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe)];
	[self.view addGestureRecognizer:swipeGestureRecognizer];
	
	_arrowIndexLightGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIndexLightGray"]];
	_arrowIndexLightGray.frame = CGRectMake(85, 28, _arrowIndexLightGray.image.size.width, _arrowIndexLightGray.image.size.height);
	
	_arrowIndexGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIndexGray"]];
	_arrowIndexGray.frame = CGRectMake(123, 18, _arrowIndexGray.image.size.width, _arrowIndexGray.image.size.height);

	
	_colorOfFirstClassify = [UIColor whiteColor];
	_colorOfSecondClassify = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
	_colorOfthirdClassify = [UIColor colorWithRed:218/255.0f green:218/255.0f blue:218/255.0f alpha:1.0f];
	
	CGRect rect = self.view.frame;
	_firstClassifyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_firstClassifyTableView.dataSource = self;
	_firstClassifyTableView.delegate = self;
//	_firstClassifyTableView.backgroundColor = _colorOfFirstClassify;
	[self.view addSubview:_firstClassifyTableView];
	
	_secondTableViewStartX = self.view.bounds.size.width / 4;
	rect.origin.x = _secondTableViewStartX;
	rect.origin.y = 64;
	rect.size.width = self.view.frame.size.width - rect.origin.x;
	rect.size.height = rect.size.height - rect.origin.y - 49;
	_secondClassifyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_secondClassifyTableView.dataSource = self;
	_secondClassifyTableView.delegate = self;
	_secondClassifyTableView.backgroundColor = _colorOfSecondClassify;
	[self.view addSubview:_secondClassifyTableView];

	_thirdTableViewStartX = self.view.bounds.size.width / 10 * 6;
	rect.origin.x = _thirdTableViewStartX;
	rect.origin.y = 64;
	rect.size.width = self.view.frame.size.width - rect.origin.x;
	_thirdClassifyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_thirdClassifyTableView.dataSource = self;
	_thirdClassifyTableView.delegate = self;
	_thirdClassifyTableView.backgroundColor = _colorOfthirdClassify;
	[self.view addSubview:_thirdClassifyTableView];
	
	//_secondClassifyTableView.hidden = _thirdClassifyTableView.hidden = YES;
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	[self.view addSubview:_loadingView];
	[_loadingView start];
	
	[[MLAPIClient shared] goodsClassifiesWithBlock:^(NSArray *multiAttributes, NSError *error) {
		_loadingView.hidden = YES;
		if (!error) {
			_goodsClassifies = [MLGoodsClassify multiWithAttributesArray:multiAttributes];
			[_firstClassifyTableView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
	
	[self showMainCategoriesOnly];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.delegate = self;
	_searchBar.placeholder = @"查找商品";
	self.navigationItem.titleView = _searchBar;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)swipe {
	if (!_thirdTableViewHidden) {
		[self hide:YES tableView:_thirdClassifyTableView animated:YES];
	} else {
		[self hide:YES tableView:_secondClassifyTableView animated:YES];
	}
}

- (void)hide:(BOOL)hide tableView:(UITableView *)tableView animated:(BOOL)animated {
	if (hide && tableView == _thirdClassifyTableView) {
		[_arrowIndexGray removeFromSuperview];
	} else if (hide && tableView == _secondClassifyTableView) {
		[_arrowIndexLightGray removeFromSuperview];
	}
	UIImageView *arrow = nil;
	CGFloat startX = 0;
	if (tableView == _thirdClassifyTableView) {
		arrow = _arrowIndexGray;
		startX = _thirdTableViewStartX;
		_thirdTableViewHidden = hide;
	} else {
		arrow = _arrowIndexLightGray;
		startX = _secondTableViewStartX;
	}
	CGRect rect = tableView.frame;
	if (hide) {
		rect.origin.x = self.view.bounds.size.width;
	} else {
		rect.origin.x = startX;
	}
	
	CGFloat duration = animated ? 0.25 : 0.0;
	[UIView animateWithDuration:duration animations:^{
		tableView.frame = rect;
//		arrow.hidden = hide;
	}];
}

- (MLGoodsClassify *)goodsClassifyInFirstIndexPath:(NSIndexPath *)firstIndexPath secondIndePath:(NSIndexPath *)secondIndexPath thirdIndexPath:(NSIndexPath *)thirdIndexPath {
	MLGoodsClassify *firstClassify = nil;
	MLGoodsClassify *secondClassify = nil;
	MLGoodsClassify *thirdClassify = nil;
	if (firstIndexPath) {
		firstClassify = _goodsClassifies[firstIndexPath.row];
	}
	if (firstIndexPath && secondIndexPath) {
		secondClassify = firstClassify.subClassifies[secondIndexPath.row];
	}
	if (thirdIndexPath && secondIndexPath && firstIndexPath) {
		thirdClassify = secondClassify.subClassifies[thirdIndexPath.row];
	}
	if (thirdClassify) return thirdClassify;
	if (secondClassify) return secondClassify;
	return firstClassify;
}

- (void)showMainCategoriesOnly {
	[self hide:YES tableView:_thirdClassifyTableView animated:NO];
	[self hide:YES tableView:_secondClassifyTableView animated:NO];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[_searchBar resignFirstResponder];
	MLSearchViewController *searchViewControler = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewControler.hidesBottomBarWhenPushed = YES;
    [searchViewControler setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:searchViewControler animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_firstClassifyTableView == tableView) {
		return 70;
	} else if (_secondClassifyTableView == tableView) {
		return 54;
	}
	return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == _firstClassifyTableView) {
		return _goodsClassifies.count;
	} else if (tableView == _secondClassifyTableView) {
		MLGoodsClassify *classify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:nil thirdIndexPath:nil];
		return classify.subClassifies.count;
	} else if (tableView == _thirdClassifyTableView) {
		MLGoodsClassify *classify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:_indexPathSelectedInSecondClassify thirdIndexPath:nil];
		return classify.subClassifies.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[UITableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	MLGoodsClassify *goodsClassify = nil;
	if (tableView == _firstClassifyTableView) {
		goodsClassify = _goodsClassifies[indexPath.row];
		[cell.imageView setImageWithURL:[NSURL URLWithString:goodsClassify.iconPath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		cell.backgroundColor = _colorOfFirstClassify;
	} else if (tableView == _secondClassifyTableView) {
		goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:indexPath thirdIndexPath:nil];
		cell.backgroundColor = _colorOfSecondClassify;
	} else if (tableView == _thirdClassifyTableView) {
		goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:_indexPathSelectedInSecondClassify thirdIndexPath:indexPath];
		cell.backgroundColor = _colorOfthirdClassify;
	}
	cell.textLabel.text = goodsClassify ? goodsClassify.name : nil;
	if (tableView == _firstClassifyTableView) {
		cell.detailTextLabel.text = goodsClassify ? goodsClassify.caption : nil;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (tableView == _firstClassifyTableView) {
		_indexPathSelectedInFirstClassify = indexPath;
		_indexPathSelectedInSecondClassify = nil;
		[self hide:NO tableView:_secondClassifyTableView animated:YES];
		[self hide:YES tableView:_thirdClassifyTableView animated:YES];
		[_secondClassifyTableView reloadData];
		[_arrowIndexLightGray removeFromSuperview];
		[cell.contentView addSubview:_arrowIndexLightGray];
		//_arrowIndexLightGray.hidden = YES;
	} else if (tableView == _secondClassifyTableView) {
		_indexPathSelectedInSecondClassify = indexPath;
		[self hide:NO tableView:_thirdClassifyTableView animated:YES];
		[_thirdClassifyTableView reloadData];
		[_arrowIndexGray removeFromSuperview];
		[cell.contentView addSubview:_arrowIndexGray];
		//_arrowIndexGray.hidden = YES;
	} else if (tableView == _thirdClassifyTableView) {
		MLSearchResultViewController *searchResultViewController = [[MLSearchResultViewController alloc] initWithNibName:nil bundle:nil];
		MLGoodsClassify *goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:_indexPathSelectedInSecondClassify thirdIndexPath:indexPath];
		searchResultViewController.goodsClassify = goodsClassify;
		[self.navigationController pushViewController:searchResultViewController animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (_firstClassifyTableView == tableView) {
		cell.backgroundColor = _colorOfFirstClassify;
	} else if (_secondClassifyTableView == tableView) {
		cell.backgroundColor = _colorOfSecondClassify;
	} else if (_thirdClassifyTableView == tableView) {
		cell.backgroundColor = _colorOfthirdClassify;
	}
}

@end
