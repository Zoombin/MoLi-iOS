//
//  MLCartViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLCartViewController.h"
#import "Header.h"
#import "MLGoodsCartTableViewCell.h"
#import "MLCartStore.h"
#import "MLPrepareOrderViewController.h"
#import "MLLoadingView.h"
#import "MLDepositViewController.h"
#import "MLNoDataView.h"
#import "MLSigninViewController.h"
#import "MJRefresh.h"

@interface MLCartViewController () <
MLGoodsCartTableViewCellDelegate,
UIAlertViewDelegate,
UITableViewDataSource, UITableViewDelegate
>

@property (readwrite) UITableView *tableView;
@property (readwrite) UIView *controlView;
@property (readwrite) UIButton *selectAllButton;
@property (readwrite) UIButton *deleteButton;
@property (readwrite) UIButton *buyButton;
@property (readwrite) NSNumber *page;
@property (readwrite) NSArray *cartStores;
@property (readwrite) BOOL editing;
@property (readwrite) MLLoadingView *loadingView;
@property (readwrite) MLNoDataView *blankCartView;
@property (readwrite) MLNoDataView *needLoginCartView;
@property (readwrite) UIAlertView *clearNotOnSaleGoodsAlertView;

@end

@implementation MLCartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"购物车", nil);
		
		UIImage *normalImage = [[UIImage imageNamed:@"Cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"CartHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	[self addEditBarButtonItem];
	
	_page = @(1);
	
	CGFloat heightForControlView = 60;
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - heightForControlView) style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	CGRect rect = CGRectZero;
	rect.size.width = self.view.frame.size.width;
	rect.size.height = heightForControlView;
	rect.origin.y = self.view.frame.size.height - rect.size.height - 50;
	
	_controlView = [[UIView alloc] initWithFrame:rect];
	_controlView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
	[self.view addSubview:_controlView];
	
	rect.origin.y = 0;
	rect.size.width = 100;
	rect.size.height = heightForControlView;
	
	UIImage *image = [UIImage imageNamed:@"GoodsUnselected"];
	UIImage *imageHighlighted = [UIImage imageNamed:@"GoodsSelected"];
	_selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_selectAllButton.frame = rect;
	[_selectAllButton setImage:image forState:UIControlStateNormal];
	[_selectAllButton setImage:imageHighlighted forState:UIControlStateSelected];
	[_selectAllButton setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
	_selectAllButton.titleLabel.font = [UIFont systemFontOfSize:20];
	[_selectAllButton setTitleColor:[UIColor fontGrayColor] forState:UIControlStateNormal];
	[_selectAllButton.titleLabel sizeToFit];
	[_selectAllButton addTarget:self action:@selector(selectAllStoreAllGoods:) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_selectAllButton];
	
	rect.size.width = 128;
	rect.origin.x = self.view.frame.size.width - rect.size.width;
	_deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_deleteButton.frame = rect;
	//[_deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
	_deleteButton.titleLabel.font = [UIFont systemFontOfSize:20];
	_deleteButton.backgroundColor = [UIColor themeColor];
	_deleteButton.hidden = YES;
	[_deleteButton addTarget:self action:@selector(deleteMultiGoods) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_deleteButton];

	_buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_buyButton.frame = rect;
	//[_buyButton setTitle:@"结算（2）" forState:UIControlStateNormal];
	_buyButton.titleLabel.font = _deleteButton.titleLabel.font;
	_buyButton.backgroundColor = _deleteButton.backgroundColor;
	[_buyButton addTarget:self action:@selector(buyMultiGoods) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_buyButton];
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	[self.view addSubview:_loadingView];
	[_loadingView start];
	
	_blankCartView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_blankCartView.imageView.image = [UIImage imageNamed:@"BlankCart"];
	_blankCartView.label.text = @"购物车还是空的\n去挑选几件中意的商品吧";
	_blankCartView.button.hidden = NO;
	[_blankCartView.button setTitle:@"开始购物" forState:UIControlStateNormal];
	_blankCartView.hidden = YES;
	[_blankCartView.button addTarget:self action:@selector(goToShopping) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_blankCartView];
	
	_needLoginCartView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_needLoginCartView.imageView.image = [UIImage imageNamed:@"NeedLoginCart"];
	_needLoginCartView.label.text = @"亲，您还没有登录\n登录之后立即开启您的魔力之旅";
	_needLoginCartView.button.hidden = NO;
	[_needLoginCartView.button setTitle:@"马上登录" forState:UIControlStateNormal];
	[_needLoginCartView.button addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_needLoginCartView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCart) name:ML_NOTIFICATION_IDENTIFIER_SYNC_CART object:nil];
    
    
    [self addPullDownRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([[MLAPIClient shared] sessionValid]) {
		[self syncCart];
	}
	_needLoginCartView.hidden = [[MLAPIClient shared] sessionValid];
	_tableView.hidden = _controlView.hidden = ![[MLAPIClient shared] sessionValid];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_SYNC_CART object:nil];
}

// 添加下拉刷新功能
- (void)addPullDownRefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf syncCart];
    }];
}

- (void)goToLogin {
	MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
}

- (void)goToShopping {
	self.tabBarController.selectedIndex = 1;
}

- (void)showClearNotOnSaleGoodsAlertView {
	_clearNotOnSaleGoodsAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"您购物车里有实效物品，要清空吗？" delegate:self cancelButtonTitle:@"不需要" otherButtonTitles:@"清空", nil];
	[_clearNotOnSaleGoodsAlertView show];
}

- (void)updateControlViewButtons {
	_selectAllButton.selected = [self selectedAllStoreAllGoods];
	[_deleteButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"删除", nil)] forState:UIControlStateNormal];
	[_buyButton setTitle:[NSString stringWithFormat:@"%@（%@）", NSLocalizedString(@"结算", nil), [self numberOfSelectedGoods]] forState:UIControlStateNormal];
}

- (NSNumber *)numberOfSelectedGoods {
	NSInteger number = 0;
	for (MLCartStore *cartStore in _cartStores) {
		for (MLGoods *goods in cartStore.multiGoods) {
			if (goods.selectedInCart) {
				number++;
			}
		}
	}
	return @(number);
}

- (NSArray *)allGoodsInAllStores {
	NSMutableArray *allGoods = [NSMutableArray array];
	for (MLCartStore *cartStore in _cartStores) {
		if (cartStore.multiGoods.count) {
			[allGoods addObjectsFromArray:cartStore.multiGoods];
		}
	}
	return allGoods;
}

- (BOOL)selectedAllStoreAllGoods {
	for (MLCartStore *cartStore in _cartStores) {
		if (!cartStore.selectedInCart) {
			return NO;
		}
		for (MLGoods *goods in cartStore.multiGoods) {
			if (!goods.selectedInCart) {
				return NO;
			}
		}
	}
	return YES;
}

- (void)selectAllStoreAllGoods:(UIButton *)sender {
	sender.selected = !sender.selected;
	for (MLCartStore *cartStore in _cartStores) {
		cartStore.selectedInCart = sender.selected;
		for (MLGoods *goods in cartStore.multiGoods) {
			goods.selectedInCart = sender.selected;
		}
	}
	[self updateControlViewButtons];
	[_tableView reloadData];
}

- (BOOL)existsNotOnSaleGoods {
	NSArray *allGoodsInAllStores = [self allGoodsInAllStores];
	for (MLGoods *goods in allGoodsInAllStores) {
		if (!goods.isOnSale.boolValue) {
			return YES;
		}
	}
	return NO;
}

- (void)addEditBarButtonItem {
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
}

- (void)addDoneBarButtonItem {
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone)];
}

- (void)editMode {
	if (![[MLAPIClient shared] sessionValid]) {
		return;
	}
	[self addDoneBarButtonItem];
	_buyButton.hidden = YES;
	_deleteButton.hidden = NO;
	_editing = YES;
	[_tableView reloadData];
}

- (void)editDone {
	if (![[MLAPIClient shared] sessionValid]) {
		return;
	}
	[self addEditBarButtonItem];
	_buyButton.hidden = NO;
	_deleteButton.hidden = YES;
	_editing = NO;
	[_tableView reloadData];
}

- (void)syncCart {
	[[MLAPIClient shared] syncCartWithPage:_page withBlock:^(NSArray *multiAttributes, NSNumber *total, NSError *error) {
		_loadingView.hidden = YES;
		if (!error) {
			_cartStores = [MLCartStore multiWithAttributesArray:multiAttributes];
			if (_cartStores.count) {
				_blankCartView.hidden = YES;
			} else {
				_blankCartView.hidden = NO;
			}
			
			if ([self existsNotOnSaleGoods]) {
				[self showClearNotOnSaleGoodsAlertView];
			}
			
            [self updateBadgeValue];
			[self updateControlViewButtons];
			[_tableView reloadData];
		}
        //取消下拉动画
        [self.tableView.header endRefreshing];
	}];
}

-(void)updateBadgeValue{
    NSArray *allgoods = [self allGoodsInAllStores];
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",allgoods.count];
}

- (void)selectOrDeselectGoodsInStore:(UIButton *)sender {
	sender.selected = !sender.selected;
	MLCartStore *cartStore = _cartStores[sender.tag];
	cartStore.selectedInCart = sender.selected;
	for (MLGoods *goods in cartStore.multiGoods) {
		goods.selectedInCart = sender.selected;
	}
	[self updateControlViewButtons];
	[_tableView reloadData];
}

- (NSArray *)selectedMultiGoods {
	NSMutableArray *selctedMultiGoods = [NSMutableArray array];
	for (MLCartStore *cartStore in _cartStores) {
		for (MLGoods *goods in cartStore.multiGoods) {
			if (goods.selectedInCart) {
				[selctedMultiGoods addObject:goods];
			}
		}
	}
	return selctedMultiGoods;
}

- (void)deleteMultiGoods {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] deleteMultiGoods:[self selectedMultiGoods] withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[self syncCart];
		}
	}];
}

- (void)buyMultiGoods {
	if (![self selectedMultiGoods].count) {
		[self displayHUDTitle:nil message:@"请先选中商品"];
		return;
	}
	
	if ([self existsNotOnSaleGoods]) {
		[self showClearNotOnSaleGoodsAlertView];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] prepareOrder:[self selectedMultiGoods] buyNow:NO withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			if (!vip) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还不是会员" message:@"现在就加入会员吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在加入", nil];
				[alertView show];
				return;
			}

			if (!multiGoodsWithError.count) {
				MLPrepareOrderViewController *prepareOrderViewController = [[MLPrepareOrderViewController alloc] initWithNibName:nil bundle:nil];
				prepareOrderViewController.hidesBottomBarWhenPushed = YES;
				prepareOrderViewController.multiGoods = [self selectedMultiGoods];
				[self.navigationController pushViewController:prepareOrderViewController animated:YES];
				return;
			} else {
				NSArray *noStorageMultiGoods = [MLGoods multiWithAttributesArray:multiGoodsWithError];
				NSArray *allGoods = [self allGoodsInAllStores];
				for	(MLGoods *g in noStorageMultiGoods) {
					for (MLGoods *goods in allGoods) {
						if ([g sameGoodsWithSameSelectedProperties:goods]) {
							goods.hasStorage = @(NO);
						}
					}
				}
				[_tableView reloadData];
				return;
			}
		}
	}];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		if (alertView == _clearNotOnSaleGoodsAlertView) {
			NSMutableArray *notOnSaleMultiGoods = [NSMutableArray array];
			NSArray *allGoodsInAllStores = [self allGoodsInAllStores];
			for (MLGoods *goods in allGoodsInAllStores) {
				if (!goods.isOnSale.boolValue) {
					[notOnSaleMultiGoods addObject:goods];
				}
			}
			[self displayHUD:@"加载中..."];
			[[MLAPIClient shared] deleteMultiGoods:notOnSaleMultiGoods withBlock:^(MLResponse *response) {
				[self displayResponseMessage:response];
				if (response.success) {
					[self syncCart];
				}
			}];
		} else {
			MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
			[self presentViewController:[[UINavigationController alloc] initWithRootViewController:depositViewController] animated:YES completion:nil];
		}
	}
}

#pragma mark - MLGoodsCartTableViewCellDelegate

- (void)willSelectGoods:(MLGoods *)goods inCartStore:(MLCartStore *)cartStore {
	goods.selectedInCart = !goods.selectedInCart;
	BOOL allSelected = YES;
	for (MLGoods *g in cartStore.multiGoods) {
		if (!g.selectedInCart) {
			allSelected = NO;
			break;
		}
	}
	cartStore.selectedInCart = allSelected;
	[self updateControlViewButtons];
	[_tableView reloadData];
}

- (void)willDeselectGoods:(MLGoods *)goods inCartStore:(MLCartStore *)cartStore {
	goods.selectedInCart = !goods.selectedInCart;
	cartStore.selectedInCart = NO;
	[self updateControlViewButtons];
	[_tableView reloadData];
}

- (void)willDecreaseQuantityOfGoods:(MLGoods *)goods {
	NSInteger quantity = goods.quantityInCart.integerValue;
	quantity--;
	if (quantity >= 0) {
		goods.quantityInCart = @(quantity);
		[self updateGoodsInCart:goods];
	}
}

- (void)willIncreaseQuantityOfGoods:(MLGoods *)goods {
	goods.quantityInCart = @(goods.quantityInCart.integerValue + 1);
	[self updateGoodsInCart:goods];
}

- (void)updateGoodsInCart:(MLGoods *)goods {
	[[MLAPIClient shared] updateMultiGoods:@[goods] withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		[_tableView reloadData];
	}];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLGoodsCartTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor whiteColor];
	
	MLCartStore *cartStore = _cartStores[section];
	UIImage *image = [UIImage imageNamed:@"GoodsUnselected"];
	UIImage *imageHighlighted = [UIImage imageNamed:@"GoodsSelected"];
	CGRect frame = CGRectZero;
	frame.size.width = 40;
	frame.size.height = 40;
	frame.origin.x = 0;
	frame.origin.y = 10;
	UIButton *selectAllInStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	selectAllInStoreButton.frame = frame;
	[selectAllInStoreButton setImage:image forState:UIControlStateNormal];
	[selectAllInStoreButton setImage:imageHighlighted forState:UIControlStateSelected];
	selectAllInStoreButton.tag = section;
	[selectAllInStoreButton addTarget:self action:@selector(selectOrDeselectGoodsInStore:) forControlEvents:UIControlEventTouchUpInside];
	selectAllInStoreButton.selected = cartStore.selectedInCart;
	[view addSubview:selectAllInStoreButton];
	
	frame.origin.x = CGRectGetMaxX(selectAllInStoreButton.frame) + 5;
	frame.size.width = tableView.frame.size.width - frame.origin.x;
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = cartStore.name;
	[view addSubview:label];
	
	return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _cartStores.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MLCartStore *cartStore = _cartStores[section];
	return cartStore.multiGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[MLGoodsCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLGoodsCartTableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	MLCartStore *cartStore = _cartStores[indexPath.section];
	MLGoods *goods = cartStore.multiGoods[indexPath.row];
	cell.delegate = self;
	cell.cartStore = cartStore;
	cell.goods = goods;
	cell.editMode = _editing;
	if (!goods.isOnSale.boolValue) {
		cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:241/255.0f alpha:1.0];
	}
	return cell;
}


@end
