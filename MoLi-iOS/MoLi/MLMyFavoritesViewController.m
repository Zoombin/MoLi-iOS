//
//  MLMyFavoritesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMyFavoritesViewController.h"
#import "Header.h"
#import "MLFavoritesViewController.h"
#import "MLFavoriteSummary.h"

@interface MLMyFavoritesViewController ()

@property (readwrite) UIView *goodsView;
@property (readwrite) UIView *flagshipStoreView;
@property (readwrite) UIView *storeView;
@property (readwrite) UILabel *goodsDetailLabel;
@property (readwrite) UILabel *flagshipStoreDetailLabel;
@property (readwrite) UILabel *storeDetailLabel;
@property (readwrite) MLFavoriteSummary *favoriteSummary;

@end

@implementation MLMyFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"我的收藏", nil);
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:scrollView];
	
	CGRect frame = CGRectZero;
	frame.size.width = 96;
	frame.size.height = 134;
	frame.origin.x = (self.view.frame.size.width - frame.size.width * 3) / 4;
	frame.origin.y = 12;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(frame.origin.y, frame.origin.x, 0, 0);
	
	_goodsView = [[UIView alloc] initWithFrame:frame];
	_goodsView.backgroundColor = [UIColor whiteColor];
	
	frame.origin.x = 30;
	frame.origin.y = 24;
	frame.size.width = 35;
	frame.size.height = 35;
	UIImageView *goodsIconView = [[UIImageView alloc] initWithFrame:frame];
	goodsIconView.image = [UIImage imageNamed:@"FavoriteGoods"];
	[_goodsView addSubview:goodsIconView];
	[scrollView addSubview:_goodsView];

	frame.origin.x = 0;
	frame.origin.y = CGRectGetMaxY(goodsIconView.frame) + 5;
	frame.size.width = CGRectGetWidth(_goodsView.frame);
	frame.size.height = 30;
	UILabel *goodsLabel = [[UILabel alloc] initWithFrame:frame];
	goodsLabel.textAlignment = NSTextAlignmentCenter;
	goodsLabel.text = NSLocalizedString(@"商品收藏", nil);
	goodsLabel.font = [UIFont systemFontOfSize:15];
	goodsLabel.textColor = [UIColor fontGrayColor];
	[_goodsView addSubview:goodsLabel];
	
	frame.origin.y = CGRectGetMaxY(goodsLabel.frame);
	frame.size.height = 20;
	_goodsDetailLabel = [[UILabel alloc] initWithFrame:frame];
	_goodsDetailLabel.textAlignment = NSTextAlignmentCenter;
	_goodsDetailLabel.textColor = [UIColor lightGrayColor];
	_goodsDetailLabel.font = [UIFont systemFontOfSize:13];
	[_goodsView addSubview:_goodsDetailLabel];
	
	frame = _goodsView.frame;
	frame.origin.x = CGRectGetMaxX(_goodsView.frame) + edgeInsets.left;
	_flagshipStoreView = [[UIView alloc] initWithFrame:frame];
	_flagshipStoreView.backgroundColor = [UIColor whiteColor];
	[scrollView addSubview:_flagshipStoreView];
	
	frame = goodsIconView.frame;
	UIImageView *flagshipStoreIconView = [[UIImageView alloc] initWithFrame:frame];
	flagshipStoreIconView.image = [UIImage imageNamed:@"FavoriteFlagshipStore"];
	[_flagshipStoreView addSubview:flagshipStoreIconView];
	
	frame = goodsLabel.frame;
	UILabel *flagshipStoreLabel = [[UILabel alloc] initWithFrame:frame];
	flagshipStoreLabel.text = NSLocalizedString(@"旗舰店收藏", nil);
	[flagshipStoreLabel sameStyleWith:goodsLabel];
	[_flagshipStoreView addSubview:flagshipStoreLabel];
	
	frame = _goodsDetailLabel.frame;
	_flagshipStoreDetailLabel = [[UILabel alloc] initWithFrame:frame];
	[_flagshipStoreDetailLabel sameStyleWith:_goodsDetailLabel];
	[_flagshipStoreView addSubview:_flagshipStoreDetailLabel];
	
	frame = _flagshipStoreView.frame;
	frame.origin.x = CGRectGetMaxX(_flagshipStoreView.frame) + edgeInsets.left;
	_storeView = [[UIView alloc] initWithFrame:frame];
	_storeView.backgroundColor = [UIColor whiteColor];
	[scrollView addSubview:_storeView];
	
	frame = flagshipStoreIconView.frame;
	UIImageView *storeIconView = [[UIImageView alloc] initWithFrame:frame];
	storeIconView.image = [UIImage imageNamed:@"FavoriteStore"];
	[_storeView addSubview:storeIconView];
	
	frame = flagshipStoreLabel.frame;
	UILabel *storeLabel = [[UILabel alloc] initWithFrame:frame];
	[storeLabel sameStyleWith:goodsLabel];
	storeLabel.text = NSLocalizedString(@"实体店收藏", nil);
	[_storeView addSubview:storeLabel];
	
	frame = _flagshipStoreDetailLabel.frame;
	_storeDetailLabel = [[UILabel alloc] initWithFrame:frame];
	[_storeDetailLabel sameStyleWith:_goodsDetailLabel];
	[_storeView addSubview:_storeDetailLabel];
	
	UITapGestureRecognizer *goodsTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favorites:)];
	[_goodsView addGestureRecognizer:goodsTapGestureRecognizer];
	
	UITapGestureRecognizer *flagshipStoreTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favorites:)];
	[_flagshipStoreView addGestureRecognizer:flagshipStoreTapGestureRecognizer];
	
	UITapGestureRecognizer *storeTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favorites:)];
	[_storeView addGestureRecognizer:storeTapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[MLAPIClient shared] myfavoritesSummaryWithBlock:^(NSDictionary *attributes, MLResponse *response) {
		if (response.success) {
			_favoriteSummary = [[MLFavoriteSummary alloc] initWithAttributes:attributes];
			_goodsDetailLabel.text = [NSString stringWithFormat:@"%@件商品", _favoriteSummary.numberOfgoods ?: @""];
			_flagshipStoreDetailLabel.text = [NSString stringWithFormat:@"%@个店铺", _favoriteSummary.numberOfFlagshipStore ?: @""];
			_storeDetailLabel.text = [NSString stringWithFormat:@"%@个实体店", _favoriteSummary.numberOfStore ?: @""];
			
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)favorites:(UITapGestureRecognizer *)tapGestureRecognizer {
	MLFavoritesViewController *favoritesViewController = [[MLFavoritesViewController alloc] initWithNibName:nil bundle:nil];
	if (tapGestureRecognizer.view == _goodsView) {
		favoritesViewController.favoriteType = MLFavoriteTypeGoods;
	} else if (tapGestureRecognizer.view == _flagshipStoreView) {
		favoritesViewController.favoriteType = MLFavoriteTypeFlagshipStore;
	} else {
		favoritesViewController.favoriteType = MLFavoriteTypeStore;
	}
    [favoritesViewController setLeftBarButtonItemAsBackArrowButton];
	[self.navigationController pushViewController:favoritesViewController animated:YES];
}




@end
