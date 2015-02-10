//
//  MLFavoritesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLFavoritesViewController.h"
#import "Header.h"
#import "MLGoods.h"
#import "MLFlagshipStore.h"
#import "MLStore.h"
#import "MLNoDataView.h"

@interface MLFavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *favorites;
@property (readwrite) NSNumber *page;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	_page = @(1);
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoFavorite"];
	_noDataView.label.text = @"收藏夹还是空的\n快去添加喜欢的商品吧";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
	
	[self fetchFavorites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchFavorites {
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	if (_favoriteType == MLFavoriteTypeGoods) {
		self.title = NSLocalizedString(@"商品收藏", nil);
		[[MLAPIClient shared] favoritesGoodsWithPage:_page withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_favorites = [MLGoods multiWithAttributesArray:multiAttributes];
				_noDataView.hidden = _favorites.count ? YES : NO;
				[_tableView reloadData];
			}
		}];
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
		self.title = NSLocalizedString(@"旗舰店收藏", nil);
		[[MLAPIClient shared] favoritesFlagshipStoreWithPage:_page withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_favorites = [MLFlagshipStore multiWithAttributesArray:multiAttributes];
				_noDataView.hidden = _favorites.count ? YES : NO;
				[_tableView reloadData];
			}
		}];
	} else {
		self.title = NSLocalizedString(@"实体店收藏", nil);
		[[MLAPIClient shared] favoritesStoreWithPage:_page withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_favorites = [MLStore multiWithAttributesArray:multiAttributes];
				_noDataView.hidden = _favorites.count ? YES : NO;
				[_tableView reloadData];
			}
		}];
	}
}

- (void)respondAfterDeleteWithResponse:(MLResponse *)response {
	[self displayResponseMessage:response];
	if (response.success) {
		[self fetchFavorites];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_favoriteType == MLFavoriteTypeGoods) {
		return 82;
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
		return 58;
	}
	return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		if (_favoriteType == MLFavoriteTypeGoods) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[UITableViewCell identifier]];
		} else {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		}
	}
	UIImage *placeholder = [UIImage imageNamed:@"Placeholder"];
	if (_favoriteType == MLFavoriteTypeGoods) {
		MLGoods *goods = _favorites[indexPath.row];
		[cell.imageView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:placeholder];
		cell.textLabel.text = goods.name;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:¥%@", NSLocalizedString(@"价格", nil), goods.price];
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
		MLFlagshipStore *flagshipStore = _favorites[indexPath.row];
		[cell.imageView setImageWithURL:[NSURL URLWithString:flagshipStore.imagePath] placeholderImage:placeholder];
		cell.textLabel.text = flagshipStore.name;
	} else {
		MLStore *store = _favorites[indexPath.row];
		[cell.imageView setImageWithURL:[NSURL URLWithString:store.imagePath] placeholderImage:placeholder];
		cell.textLabel.text = store.name;
	}
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (_favoriteType == MLFavoriteTypeGoods) {
			MLGoods *goods = _favorites[indexPath.row];
			[[MLAPIClient shared] multiGoods:@[goods.ID] defavourWithBlock:^(MLResponse *response) {
				[self respondAfterDeleteWithResponse:response];
			}];
		} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
			MLFlagshipStore *flagshipStore = _favorites[indexPath.row];
			[[MLAPIClient shared] multiGoods:@[flagshipStore.ID] defavourWithBlock:^(MLResponse *response) {
				[self respondAfterDeleteWithResponse:response];
			}];
		} else {
			MLStore *store = _favorites[indexPath.row];
			[[MLAPIClient shared] stores:@[store.ID] defavourWithBlock:^(MLResponse *response) {
				[self respondAfterDeleteWithResponse:response];
			}];
		}
	}
}

@end
