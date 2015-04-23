//
//  MLFavoritesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLFavoritesViewController.h"
#import "MLFavoritesGoodsTableViewCell.h"
#import "MLFavoritesStoreTableViewCell.h"
#import "MLGoodsDetailsViewController.h"
#import "MLStoreDetailsViewController.h"
#import "MLFlagshipStoreViewController.h"
#import "Header.h"
#import "MLGoods.h"
#import "MLFlagshipStore.h"
#import "MLStore.h"
#import "MLNoDataView.h"

@interface MLFavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *favorites;
@property (readwrite) NSInteger page;
@property (readwrite) MLNoDataView *noDataView;
@property (readwrite) BOOL noMore;

@end

@implementation MLFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	_page = 1;
	_favorites = [NSMutableArray array];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoFavorite"];
	_noDataView.label.text = @"收藏夹还是空的\n快去添加喜欢的商品吧";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
	
	if (_favoriteType == MLFavoriteTypeGoods) {
		self.title = NSLocalizedString(@"商品收藏", nil);
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
		self.title = NSLocalizedString(@"旗舰店收藏", nil);
	} else {
		self.title = NSLocalizedString(@"实体店收藏", nil);
	}
	[self fetchFavorites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchFavorites {
	if (_noMore) return;
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	if (_favoriteType == MLFavoriteTypeGoods) {
		[[MLAPIClient shared] favoritesGoodsWithPage:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_page++;
				NSArray *tmp = [MLGoods multiWithAttributesArray:multiAttributes];
				if (tmp.count) {
					[_favorites addObjectsFromArray:tmp];
				} else {
					_noMore = YES;
				}
				_noDataView.hidden = _favorites.count ? YES : NO;
				[_tableView reloadData];
			}
		}];
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
		[[MLAPIClient shared] favoritesFlagshipStoreWithPage:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_page++;
				NSArray *tmp = [MLFlagshipStore multiWithAttributesArray:multiAttributes];
				if (tmp.count) {
					[_favorites addObjectsFromArray:tmp];
				} else {
					_noMore = YES;
				}
				_noDataView.hidden = _favorites.count ? YES : NO;
				[_tableView reloadData];
			}
		}];
	} else {
		[[MLAPIClient shared] favoritesStoreWithPage:@(_page) withBlock:^(NSArray *multiAttributes, NSError *error) {
			[self hideHUD:YES];
			if (!error) {
				_page++;
				NSArray *tmp = [MLStore multiWithAttributesArray:multiAttributes];
				if (tmp.count) {
					[_favorites addObjectsFromArray:tmp];
				} else {
					_noMore = YES;
				}
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

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (endScrolling >= scrollView.contentSize.height - 15) {
		[self fetchFavorites];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (_noMore && _favorites.count > 0) {
		return 46;
	}
	return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_favoriteType == MLFavoriteTypeGoods) {
		return 80;
	} else {
		return 60;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	if (_noMore && _favorites.count > 0) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.bounds.size.width / 2 - 90, 0, 46, 46)];
		imageView.image = [UIImage imageNamed:@"Placeholder"];
		[view addSubview:imageView];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 46)];
		label.text = @"您已经看到最后了";
		label.font = [UIFont systemFontOfSize:13];
		label.textColor = [UIColor fontGrayColor];
		label.textAlignment = NSTextAlignmentCenter;
		[view addSubview:label];
	}
	return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		if (_favoriteType == MLFavoriteTypeGoods) {
			cell = [[MLFavoritesGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		} else {
			cell = [[MLFavoritesStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		}
	}
    
	if (_favoriteType == MLFavoriteTypeGoods) {
		MLGoods *goods = _favorites[indexPath.row];
        [(MLFavoritesGoodsTableViewCell*)cell updateValue:goods];
	} else if (_favoriteType == MLFavoriteTypeFlagshipStore) {
        MLFlagshipStore *flagshipStore = _favorites[indexPath.row];
        [(MLFavoritesStoreTableViewCell*)cell updateMLFlagshipStore:flagshipStore];
	} else {
        MLStore *store = _favorites[indexPath.row];
        [(MLFavoritesStoreTableViewCell*)cell updateMLStore:store];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MLFavoritesGoodsTableViewCell class]]) {
        MLGoods *goods = _favorites[indexPath.row];
		if (goods.isOnSale.boolValue) {
			MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
			goodsDetailsViewController.previousViewControllerHidenBottomBar = YES;
			goodsDetailsViewController.goods = goods;
			[self.navigationController pushViewController:goodsDetailsViewController animated:YES];
		} else {
			[self displayHUDTitle:nil message:@"该商品已失效，无法查看详情！"];
			return;
		}
    }
    else {
        id store = _favorites[indexPath.row];
        if([store isKindOfClass:[MLStore class]]) {
            //普通店铺
            MLStoreDetailsViewController *detailCtr = [[MLStoreDetailsViewController alloc] initWithNibName:nil bundle:nil];
            detailCtr.store = store;
            [self.navigationController pushViewController:detailCtr animated:YES];
        }
        else if([store isKindOfClass:[MLFlagshipStore class]]) {
            //旗舰店铺
            MLFlagshipStoreViewController *detailCtr = [[MLFlagshipStoreViewController alloc] initWithNibName:nil bundle:nil];
            detailCtr.flagshipStore = store;
            [self.navigationController pushViewController:detailCtr animated:YES];
        }
    }
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
