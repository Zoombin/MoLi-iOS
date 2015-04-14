//
//  MLSearchViewController.m
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLSearchViewController.h"
#import "Header.h"
#import "ZBBottomIndexView.h"
#import "MLSearchResultViewController.h"
#import "MLStoresSearchResultViewController.h"
#import "UIButton+DashLine.h"

@interface MLSearchViewController () <
ZBBottomIndexViewDelegate,
UISearchBarDelegate
>

@property (readwrite) UISearchBar *searchBar;
@property (readwrite) UIScrollView *scrollView;
@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) NSArray *hotWords;
@property (readwrite) NSArray *searchHistoryWords;
@property (readwrite) NSMutableArray *wordButtons;
@property (readwrite) UIButton *clearSearchHistoryButton;

@end

@implementation MLSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"搜索";
		UIImage *normalImage = [[UIImage imageNamed:@"Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"SearchHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	if (!_isRoot) {
		[self setLeftBarButtonItemAsBackToRootArrowButton];
	}
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
	
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.searchBarStyle = UISearchBarIconBookmark;
	_searchBar.delegate = self;
	self.navigationItem.titleView = _searchBar;
	_searchBar.placeholder = @"搜索商品";
	if (_isSearchStores) {
		_searchBar.placeholder = @"搜索商家";
	}
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.showsHorizontalScrollIndicator = YES;
	_scrollView.showsVerticalScrollIndicator = YES;
	[self.view addSubview:_scrollView];
	
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 34)];
    [_bottomIndexView setHighlights:@[@"SearchRecentlyHighlighted", @"SearchHotHighlighted"]];
    [_bottomIndexView setNormals:@[@"SearchRecently", @"SearchHot"]];
	[_bottomIndexView setItems:@[@"最近搜索", @"热门搜索"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:14]];
	[_scrollView addSubview:_bottomIndexView];
	
	_clearSearchHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	CGFloat startY = _isRoot ? self.view.bounds.size.height - 50 - 64 - 49: self.view.bounds.size.height - 50 - 64;
	_clearSearchHistoryButton.frame = CGRectMake(0, startY, self.view.bounds.size.width, 50);
	_clearSearchHistoryButton.backgroundColor = [UIColor themeColor];
	_clearSearchHistoryButton.showsTouchWhenHighlighted = YES;
	[_clearSearchHistoryButton setTitle:@"清空历史" forState:UIControlStateNormal];
	[_clearSearchHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_clearSearchHistoryButton addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_clearSearchHistoryButton];
	
	
	if (_isSearchStores) {
		_searchHistoryWords = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_STORES_HISTORY];
	} else {
		_searchHistoryWords = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_GOODS_HISTORY];
	}
	[self showSearchWords:_searchHistoryWords];

	[[MLAPIClient shared] searchHotwordsForGoods:!_isSearchStores withBlock:^(NSArray *words, MLResponse *response) {
		[self displayResponseMessage:response];		
		if (response.success) {
			_hotWords = [NSArray arrayWithArray:words];
		}
	}];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_searchBar action:@selector(resignFirstResponder)];
	[_scrollView addGestureRecognizer:tap];

	[self.view addGestureRecognizer:[_bottomIndexView leftSwipeGestureRecognizer]];
	[self.view addGestureRecognizer:[_bottomIndexView rightSwipeGestureRecognizer]];
}

- (void)showSearchWords:(NSArray *)words {
	for (UIButton *button in _wordButtons) {
		[button removeFromSuperview];
	}
	_wordButtons = [NSMutableArray array];
	NSInteger numberPerLine = 3;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(50, 15, 15, 15);
	CGFloat buttonWidth = 86;
	if ([UIScreen mainScreen].bounds.size.width > 320) {
		buttonWidth = 102;
	}
	CGRect rect = CGRectMake(edgeInsets.left, edgeInsets.top, buttonWidth, 36);
	for	(int i = 0; i < words.count;) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:words[i] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
		button.titleLabel.adjustsFontSizeToFitWidth = YES;
		button.frame = rect;
		[button addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
		i++;
		rect.origin.x += rect.size.width + edgeInsets.left;
		if (i % numberPerLine == 0) {
			rect.origin.x = edgeInsets.left;
			rect.origin.y += rect.size.height + edgeInsets.bottom;
		}
        [button drawDashedBorder];
		[_scrollView addSubview:button];
		[_wordButtons addObject:button];
	}
	_clearSearchHistoryButton.hidden = words.count ? NO : YES;
}

- (void)search:(UIButton *)button {
	NSString *string = button.titleLabel.text;
	_searchBar.text = string;
	[self search];
}

- (void)search {
	if (!_searchBar.text.length) {
		[self displayHUDTitle:nil message:@"请输入搜索关键字"];
		return;
	}
	
	NSMutableArray *tmp = [NSMutableArray array];
	if (_searchHistoryWords.count) {
		tmp = [NSMutableArray arrayWithArray:_searchHistoryWords];
	}
	if (![tmp containsObject:_searchBar.text]) {
		[tmp insertObject:_searchBar.text atIndex:0];
	}
	_searchHistoryWords = [NSArray arrayWithArray:tmp];
	if (_isSearchStores) {
		[[NSUserDefaults standardUserDefaults] setObject:_searchHistoryWords forKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_STORES_HISTORY];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:_searchHistoryWords forKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_GOODS_HISTORY];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if (_isSearchStores) {
		MLStoresSearchResultViewController *storesSearchResultViewController = [[MLStoresSearchResultViewController alloc] initWithNibName:nil bundle:nil];
		storesSearchResultViewController.searchString = _searchBar.text;
		storesSearchResultViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:storesSearchResultViewController animated:YES];
	} else {
		MLSearchResultViewController *searchResultViewController = [[MLSearchResultViewController alloc] initWithNibName:nil bundle:nil];
		searchResultViewController.searchString = _searchBar.text;
		[self.navigationController pushViewController:searchResultViewController animated:YES];
	}
}

- (void)clearSearchHistory {
	if (_isSearchStores) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_STORES_HISTORY];
	} else {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:ML_USER_DEFAULT_IDENTIFIER_SEARCH_GOODS_HISTORY];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self displayHUDTitle:nil message:@"清除中..."];
	_searchHistoryWords = [NSArray array];
	[self showSearchWords:_searchHistoryWords];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
	if (selectedIndex == 0) {
		[self showSearchWords:_searchHistoryWords];
		_clearSearchHistoryButton.hidden = NO;
	} else {
		[self showSearchWords:_hotWords];
		_clearSearchHistoryButton.hidden = YES;
	}
}

@end
