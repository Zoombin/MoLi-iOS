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
#import "MLCategoryTableViewCell.h"

static CGFloat const heightOfFirstTableViewCell = 70;
static CGFloat const heightOfSecondTableViewCell = 54;
static CGFloat const heightOfThirdTableViewCell = 45;

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
@property (readwrite) CGFloat secondTableViewStartX;
@property (readwrite) CGFloat thirdTableViewStartX;
@property (readwrite) BOOL secondableViewHidden;
@property (readwrite) BOOL thirdTableViewHidden;
@property (readwrite) MLNoDataView *badNetworkingView;

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

	
	_colorOfFirstClassify = [UIColor whiteColor];
	_colorOfSecondClassify = [UIColor colorWithRed:245/255.0f green:246/255.0f blue:247/255.0f alpha:1.0f];
	_colorOfthirdClassify = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
	
	CGRect rect = self.view.frame;
	_firstClassifyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_firstClassifyTableView.dataSource = self;
    _firstClassifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_firstClassifyTableView.delegate = self;
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
	_secondClassifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_secondClassifyTableView];

    _thirdTableViewStartX = self.view.bounds.size.width / 10 * 6;
	rect.origin.x = _thirdTableViewStartX;
	rect.origin.y = 64;
	rect.size.width = self.view.frame.size.width - rect.origin.x;
	_thirdClassifyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_thirdClassifyTableView.dataSource = self;
	_thirdClassifyTableView.delegate = self;
	_thirdClassifyTableView.backgroundColor = _colorOfthirdClassify;
	_thirdClassifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_thirdClassifyTableView];
	
	//_secondClassifyTableView.hidden = _thirdClassifyTableView.hidden = YES;
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	//[self.view addSubview:_loadingView];
	//[_loadingView start];
	
	_badNetworkingView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_badNetworkingView.imageView.image = [UIImage imageNamed:@"BadNetworking"];
    [_badNetworkingView.button setTitle:@"点击重新加载" forState:UIControlStateNormal];
	_badNetworkingView.label.text = @"网络不佳";
	_badNetworkingView.hidden = YES;
    _badNetworkingView.delegate = self;
    _badNetworkingView.button.hidden = NO;
	[self.view addSubview:_badNetworkingView];
}

- (void)noDataViewReloadData {
    [self showMainCategoriesOnly];
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.searchBarStyle = UISearchBarIconBookmark;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找商品";
    self.navigationItem.titleView = _searchBar;
    
    [[MLAPIClient shared] goodsClassifiesWithBlock:^(NSArray *multiAttributes, NSError *error) {
        _loadingView.hidden = YES;
        if (!error) {
            _goodsClassifies = [MLGoodsClassify multiWithAttributesArray:multiAttributes];
            [_firstClassifyTableView reloadData];
            _badNetworkingView.hidden = YES;
            _firstClassifyTableView.hidden = NO;
            _secondClassifyTableView.hidden = NO;
            _thirdClassifyTableView.hidden = NO;
        } else {
            [self displayHUDTitle:nil message:error.localizedDescription];
            _badNetworkingView.hidden = NO;
            _firstClassifyTableView.hidden = YES;
            _secondClassifyTableView.hidden = YES;
            _thirdClassifyTableView.hidden = YES;
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self showMainCategoriesOnly];
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.delegate = self;
	_searchBar.placeholder = @"查找商品";
	self.navigationItem.titleView = _searchBar;
	
	[[MLAPIClient shared] goodsClassifiesWithBlock:^(NSArray *multiAttributes, NSError *error) {
		_loadingView.hidden = YES;
		if (!error) {
			_goodsClassifies = [MLGoodsClassify multiWithAttributesArray:multiAttributes];
			[_firstClassifyTableView reloadData];
			_badNetworkingView.hidden = YES;
			_firstClassifyTableView.hidden = NO;
			_secondClassifyTableView.hidden = NO;
			_thirdClassifyTableView.hidden = NO;
		} else {
			[self displayHUDTitle:nil message:error.localizedDescription];
			_badNetworkingView.hidden = NO;
			_firstClassifyTableView.hidden = YES;
			_secondClassifyTableView.hidden = YES;
			_thirdClassifyTableView.hidden = YES;
		}
	}];
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

- (void)delayShow:(id)sender {
    UIImageView *imgView = (UIImageView *)sender;
    imgView.hidden = NO;
}

- (void)hide:(BOOL)hide tableView:(UITableView *)tableView animated:(BOOL)animated {
	CGFloat startX = 0;
	if (tableView == _thirdClassifyTableView) {
		startX = _thirdTableViewStartX;
        UITableViewCell *cell = [_secondClassifyTableView cellForRowAtIndexPath:_indexPathSelectedInSecondClassify];
        UIImageView *imageview = (UIImageView*)[cell viewWithTag:12321];
        if (!hide) {
            if (_thirdTableViewHidden) {
                [self performSelector:@selector(delayShow:) withObject:imageview afterDelay:0.25];
            } else {
                imageview.hidden = NO;
            }
        } else {
            imageview.hidden = hide;
        }
        _thirdTableViewHidden = hide;
	} else {
		startX = _secondTableViewStartX;
        UITableViewCell *cell = [_firstClassifyTableView cellForRowAtIndexPath:_indexPathSelectedInFirstClassify];
        UIImageView *imageview = (UIImageView*)[cell viewWithTag:12321];
        if (!hide) {
            if (_secondableViewHidden) {
                [self performSelector:@selector(delayShow:) withObject:imageview afterDelay:0.25];
            } else {
                imageview.hidden = NO;
            }
        } else {
            imageview.hidden = hide;
        }
        if (_indexPathSelectedInSecondClassify) {
            UITableViewCell *cell2 = [_secondClassifyTableView cellForRowAtIndexPath:_indexPathSelectedInSecondClassify];
            [cell2.textLabel setTextColor:[UIColor blackColor]];
        }
        _secondableViewHidden = hide;

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
	searchViewControler.popTargetIsRoot = YES;
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
		return heightOfFirstTableViewCell;
	} else if (_secondClassifyTableView == tableView) {
		return heightOfSecondTableViewCell;
	}
	return heightOfThirdTableViewCell;
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
	Class class = nil;
	if (tableView == _firstClassifyTableView) {
		class = [MLCategoryTableViewCell class];
	} else {
		class = [UITableViewCell class];
	}
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[class identifier]];
    if (!cell) {
        cell = [[class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[class identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIndexLightGray"]];
        arrowImageView.frame = CGRectMake(85, 28, arrowImageView.image.size.width, arrowImageView.image.size.height);
        arrowImageView.hidden = YES;
        arrowImageView.tag = 12321;
        [cell addSubview:arrowImageView];

    }

	MLGoodsClassify *goodsClassify = nil;
	if (tableView == _firstClassifyTableView) {
		goodsClassify = _goodsClassifies[indexPath.row];
		MLCategoryTableViewCell *categoryCell = (MLCategoryTableViewCell *)cell;
		categoryCell.goodsClassify = goodsClassify;
		categoryCell.backgroundColor = _colorOfFirstClassify;
        
        UIImageView *arrowImageView = (UIImageView *)[cell viewWithTag:12321];
        arrowImageView.image = [UIImage imageNamed:@"ArrowIndexLightGray"];
        BOOL hidden = !_indexPathSelectedInFirstClassify || indexPath.row != _indexPathSelectedInFirstClassify.row;
        if (hidden) {
            arrowImageView.hidden = hidden;
        }
        
        arrowImageView.frame = CGRectMake(_secondTableViewStartX - arrowImageView.frame.size.width, 28, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
        
	} else if (tableView == _secondClassifyTableView) {
		goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:indexPath thirdIndexPath:nil];
        cell.backgroundColor = _colorOfSecondClassify;
        BOOL hidden = !_indexPathSelectedInSecondClassify || indexPath.row != _indexPathSelectedInSecondClassify.row;
        UIImageView *arrowImageView = (UIImageView *)[cell viewWithTag:12321];
        arrowImageView.image = [UIImage imageNamed:@"ArrowIndexGray"];
        if (hidden) {
            arrowImageView.hidden = YES;
        }
        
        arrowImageView.frame = CGRectMake(_thirdTableViewStartX - _secondTableViewStartX - arrowImageView.frame.size.width, 18, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
		
		UIView *line = [UIView borderLineWithFrame:CGRectMake(20, heightOfSecondTableViewCell - 1, tableView.bounds.size.width, 1)];
		[cell addSubview:line];
	} else if (tableView == _thirdClassifyTableView) {
		goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:_indexPathSelectedInSecondClassify thirdIndexPath:indexPath];
		cell.backgroundColor = _colorOfthirdClassify;
		
		CGRect rect = CGRectMake(20, heightOfThirdTableViewCell - 2, tableView.bounds.size.width, 1);
		
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor colorWithRed:194/255.0f green:195/255.0f blue:196/255.0f alpha:1.0];
		[cell addSubview:line];
		
		rect.origin.y += 1;
		UIView *line2 = [[UIView alloc] initWithFrame:rect];
		line2.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:242/255.0f alpha:1.0];
		[cell addSubview:line2];
	}
	if (tableView != _firstClassifyTableView) {
		cell.textLabel.text = goodsClassify ? goodsClassify.name : nil;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == _firstClassifyTableView) {
		_indexPathSelectedInFirstClassify = indexPath;
		_indexPathSelectedInSecondClassify = nil;
		[self hide:NO tableView:_secondClassifyTableView animated:YES];
		[self hide:YES tableView:_thirdClassifyTableView animated:YES];

        [_firstClassifyTableView reloadData];
		[_secondClassifyTableView reloadData];
		//_arrowIndexLightGray.hidden = YES;
	} else if (tableView == _secondClassifyTableView) {
        if (_indexPathSelectedInSecondClassify) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:_indexPathSelectedInSecondClassify];
            [cell.textLabel setTextColor:[UIColor blackColor]];
        }
		_indexPathSelectedInSecondClassify = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor colorWithRed:228.0/255 green:47.0/255 blue:5/255.0 alpha:1]];
		[self hide:NO tableView:_thirdClassifyTableView animated:YES];
        [_secondClassifyTableView reloadData];
		[_thirdClassifyTableView reloadData];
		//_arrowIndexGray.hidden = YES;
	} else if (tableView == _thirdClassifyTableView) {
		MLSearchResultViewController *searchResultViewController = [[MLSearchResultViewController alloc] initWithNibName:nil bundle:nil];
		MLGoodsClassify *goodsClassify = [self goodsClassifyInFirstIndexPath:_indexPathSelectedInFirstClassify secondIndePath:_indexPathSelectedInSecondClassify thirdIndexPath:indexPath];
		searchResultViewController.goodsClassify = goodsClassify;
		searchResultViewController.popTargetIsRoot = YES;
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
