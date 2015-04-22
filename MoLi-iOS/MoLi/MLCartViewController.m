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
#import "MLGoodsDetailsViewController.h"

static CGFloat const heightForControlView = 50;
static NSString const *sumLabelTextPrefix = @"合计:";

@interface MLCartViewController () <
MLGoodsCartTableViewCellDelegate,
UIAlertViewDelegate,
UITableViewDataSource, UITableViewDelegate
, MLNoDataViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UIView *controlView;
@property (readwrite) UIButton *selectAllButton;
@property (readwrite) UIButton *deleteButton;
@property (readwrite) UIButton *buyButton;
@property (readwrite) UILabel *sumLabel;
@property (readwrite) NSNumber *page;
@property (readwrite) NSArray *cartStores;
@property (readwrite) BOOL editing;
@property (readwrite) MLLoadingView *loadingView;
@property (readwrite) MLNoDataView *blankCartView;
@property (readwrite) MLNoDataView *needLoginCartView;
@property (readwrite) MLNoDataView *badNetworkingView;
@property (readwrite) UIAlertView *clearNotOnSaleGoodsAlertView;
@property (readwrite) NSNumber *sum;

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
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - heightForControlView) style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
    
    [_tableView addMoLiHeadView];
	
	CGRect rect = CGRectZero;
	rect.size.width = self.view.frame.size.width;
	rect.size.height = heightForControlView;
	rect.origin.y = self.view.frame.size.height - rect.size.height - 50;
	
	_controlView = [[UIView alloc] initWithFrame:rect];
	_controlView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
	_controlView.hidden = YES;
	[self.view addSubview:_controlView];
	
	rect.origin.y = 0;
	rect.size.width = 86;
	rect.size.height = heightForControlView;
	
	UIImage *image = [UIImage imageNamed:@"GoodsUnselected"];
	UIImage *imageHighlighted = [UIImage imageNamed:@"GoodsSelected"];
	_selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_selectAllButton.frame = rect;
	[_selectAllButton setImage:image forState:UIControlStateNormal];
	[_selectAllButton setImage:imageHighlighted forState:UIControlStateSelected];
	_selectAllButton.titleLabel.font = [UIFont systemFontOfSize:16];
	[_selectAllButton setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
	[_selectAllButton setTitleColor:[UIColor fontGrayColor] forState:UIControlStateNormal];
	[_selectAllButton addTarget:self action:@selector(selectAllStoreAllGoods:) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_selectAllButton];
	
	rect.origin.x = CGRectGetMaxX(_selectAllButton.frame);
	rect.origin.y -= 3;
	rect.size.width = 120;
	_sumLabel = [[UILabel alloc] initWithFrame:rect];
	_sumLabel.font = _selectAllButton.titleLabel.font;
	_sumLabel.textColor = _selectAllButton.titleLabel.textColor;
	_sumLabel.adjustsFontSizeToFitWidth = YES;
	[_controlView addSubview:_sumLabel];
	[self updateSum];
	
	rect.size.width = 102;
	rect.origin.x = self.view.frame.size.width - rect.size.width;
	rect.origin.y += 3;
	_deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_deleteButton.frame = rect;
	_deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	_deleteButton.titleLabel.font = [UIFont systemFontOfSize:20];
	_deleteButton.backgroundColor = [UIColor themeColor];
	_deleteButton.hidden = YES;
	[_deleteButton addTarget:self action:@selector(deleteMultiGoods) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_deleteButton];

	_buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_buyButton.frame = rect;
	_buyButton.titleLabel.font = _deleteButton.titleLabel.font;
	_buyButton.backgroundColor = _deleteButton.backgroundColor;
	_buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[_buyButton addTarget:self action:@selector(buyMultiGoods) forControlEvents:UIControlEventTouchUpInside];
	[_controlView addSubview:_buyButton];
	
	rect.size = [MLLoadingView size];
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = (self.view.bounds.size.height - rect.size.height) / 2 - 30;
	_loadingView = [[MLLoadingView alloc] initWithFrame:rect];
	//[self.view addSubview:_loadingView];
	if ([[MLAPIClient shared] sessionValid]) {
		[_loadingView start];
	} else {
		_loadingView.hidden = YES;
	}
	
	_blankCartView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_blankCartView.imageView.image = [UIImage imageNamed:@"BlankCart"];
	_blankCartView.label.text = @"购物车还是空的\n去挑选几件中意的商品吧";
	_blankCartView.button.hidden = NO;
	[_blankCartView.button setTitle:@"开始购物" forState:UIControlStateNormal];
	_blankCartView.hidden = YES;
	[_blankCartView.button addTarget:self action:@selector(goToShopping) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_blankCartView];
	
	_badNetworkingView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_badNetworkingView.imageView.image = [UIImage imageNamed:@"BadNetworking"];
    [_badNetworkingView.button setTitle:@"点击重新加载" forState:UIControlStateNormal];
	_badNetworkingView.label.text = @"网络不佳";
	_badNetworkingView.hidden = YES;
    _badNetworkingView.button.hidden = NO;
    _badNetworkingView.delegate = self;
	[self.view addSubview:_badNetworkingView];
	
	_needLoginCartView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_needLoginCartView.imageView.image = [UIImage imageNamed:@"NeedLoginCart"];
	_needLoginCartView.label.text = @"亲，您还没有登录\n登录之后立即开启您的魔力之旅";
	_needLoginCartView.button.hidden = NO;
	[_needLoginCartView.button setTitle:@"马上登录" forState:UIControlStateNormal];
	[_needLoginCartView.button addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_needLoginCartView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCart) name:ML_NOTIFICATION_IDENTIFIER_SYNC_CART object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCartBadge) name:ML_NOTIFICATION_IDENTIFIER_SIGNOUT object:nil];
	
    [self addPullDownRefresh];
}

- (void)noDataViewReloadData {
    if ([[MLAPIClient shared] sessionValid]) {
        [self syncCart];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([[MLAPIClient shared] sessionValid]) {
		[self syncCart];
	}
	_needLoginCartView.hidden = [[MLAPIClient shared] sessionValid];
	_tableView.hidden = ![[MLAPIClient shared] sessionValid];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_SYNC_CART object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_SIGNOUT object:nil];
}

- (void)clearCartBadge {
	self.tabBarItem.badgeValue = nil;
}

// 添加下拉刷新功能
- (void)addPullDownRefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf syncCart];
    }];
    
    self.tableView.header.updatedTimeHidden = YES;
}

- (void)goToLogin {
	MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
}

- (void)goToShopping {
	self.tabBarController.selectedIndex = 1;
}

- (void)showClearNotOnSaleGoodsAlertView {
	_clearNotOnSaleGoodsAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"您购物车里有实效物品，是否清空？" delegate:self cancelButtonTitle:@"不需要" otherButtonTitles:@"清空", nil];
	[_clearNotOnSaleGoodsAlertView show];
}

- (void)updateControlViewButtons {
	_selectAllButton.selected = [self selectedAllStoreAllGoods];
	[_deleteButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"删除", nil)] forState:UIControlStateNormal];
	BOOL selectedNone = [self selectedNoneStoreNoneGoods];
	_buyButton.backgroundColor = selectedNone ? [UIColor grayColor] : [UIColor themeColor];
	_buyButton.enabled = !selectedNone;
	[_buyButton setTitle:[NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"结算", nil), [self numberOfSelectedGoods]] forState:UIControlStateNormal];
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

- (BOOL)selectedNoneStoreNoneGoods {
	for (MLCartStore *cartStore in _cartStores) {
		if (cartStore.selectedInCart) {
			return NO;
		}
		for (MLGoods *goods in cartStore.multiGoods) {
			if (goods.selectedInCart) {
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
	[self updateSum];
	[self updateControlViewButtons];
	[_tableView reloadData];
}

- (void)deselectAllStoreAllGoods {
	_selectAllButton.selected = NO;
	for (MLCartStore *cartStore in _cartStores) {
		cartStore.selectedInCart = NO;
		for (MLGoods *goods in cartStore.multiGoods) {
			goods.selectedInCart = NO;
		}
	}
	[self updateSum];
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
	_sumLabel.hidden = YES;
	_buyButton.hidden = YES;
	_deleteButton.hidden = NO;
	_editing = YES;
	[self deselectAllStoreAllGoods];
}

- (void)editDone {
	if (![[MLAPIClient shared] sessionValid]) {
		return;
	}
	[self addEditBarButtonItem];
	_sumLabel.hidden = NO;
	_buyButton.hidden = NO;
	_deleteButton.hidden = YES;
	_editing = NO;
	[self deselectAllStoreAllGoods];
	[self updateSum];
}

- (void)updateSum {
	_sum = @(0);
	
	NSArray *allGoodsInAllStores = [self allGoodsInAllStores];
	for (MLGoods *goods in allGoodsInAllStores) {
		if (goods.selectedInCart) {
			_sum = @(_sum.floatValue + goods.price.floatValue * goods.quantityInCart.integerValue);
		}
	}
	
	NSString *string = [NSString stringWithFormat:@"%@¥%.2f", sumLabelTextPrefix, _sum.floatValue];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor themeColor], NSFontAttributeName : [UIFont systemFontOfSize:22]} range:NSMakeRange(sumLabelTextPrefix.length, string.length - sumLabelTextPrefix.length)];
	_sumLabel.attributedText = attributedString;
}

- (void)syncCart {
	[[MLAPIClient shared] syncCartWithPage:_page withBlock:^(NSArray *multiAttributes, NSNumber *total, NSError *error) {
		_loadingView.hidden = YES;
		if (!error) {
			_cartStores = [MLCartStore multiWithAttributesArray:multiAttributes];
			_blankCartView.hidden = _cartStores.count ? YES : NO;
			_controlView.hidden = _cartStores.count ? NO : YES;
			
			if ([self existsNotOnSaleGoods]) {
				[self showClearNotOnSaleGoodsAlertView];
			}
			
			_badNetworkingView.hidden = YES;
            [self updateBadgeValue];
			[self updateSum];
			[self updateControlViewButtons];
			[_tableView reloadData];
		} else {
            
            if (_cartStores.count==0) {
                _badNetworkingView.hidden = NO;
            }
			_blankCartView.hidden = YES;
		}
        //取消下拉动画
        [self.tableView.header endRefreshing];
	}];
}

-(void)updateBadgeValue {
    NSArray *allgoods = [self allGoodsInAllStores];
	if (allgoods.count == 0) {
		[self clearCartBadge];
	} else {
		//self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",allgoods.count];
	}
}

- (void)selectOrDeselectGoodsInStore:(UIButton *)sender {
	sender.selected = !sender.selected;
	MLCartStore *cartStore = _cartStores[sender.tag];
	cartStore.selectedInCart = sender.selected;
	for (MLGoods *goods in cartStore.multiGoods) {
		goods.selectedInCart = sender.selected;
	}
	[self updateSum];
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
	[[MLAPIClient shared] prepareOrder:[self selectedMultiGoods] buyNow:NO addressID:nil withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			if (!vip) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"成为会员才能购物哦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在加入", nil];
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
	[self updateSum];
	[_tableView reloadData];
}

- (void)willDeselectGoods:(MLGoods *)goods inCartStore:(MLCartStore *)cartStore {
	goods.selectedInCart = !goods.selectedInCart;
	cartStore.selectedInCart = NO;
	[self updateControlViewButtons];
	[self updateSum];
	[_tableView reloadData];
}

- (void)willDecreaseQuantityOfGoods:(MLGoods *)goods {
	NSInteger quantity = goods.quantityInCart.integerValue;
	quantity--;
	if (quantity >= 0) {
		goods.quantityInCart = @(quantity);
		[self updateGoodsInCart:goods];
	}
	[self updateSum];
}

- (void)willIncreaseQuantityOfGoods:(MLGoods *)goods {
	NSInteger quantity = goods.quantityInCart.integerValue;
	quantity++;
	if (quantity > goods.stock.integerValue) {
		quantity = goods.stock.integerValue;
		[self displayHUDTitle:nil message:[NSString stringWithFormat:@"最大数量%d", quantity] duration:1];
	}
	
//	if (quantity >= 100000) {
//		[self displayHUDTitle:nil message:@"请填写合理数量"];
//		quantity = 99999;
//	}

	goods.quantityInCart = @(quantity);
	[self updateGoodsInCart:goods];
	[self updateSum];
}

- (void)updateGoodsInCart:(MLGoods *)goods {
	[[MLAPIClient shared] updateMultiGoods:@[goods] withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		[self updateSum];
		[_tableView reloadData];
	}];
}

- (void)didEndEditingGoods:(MLGoods *)goods quantity:(NSInteger)quantity inTextField:(UITextField *)textField {
	if (quantity == 0) {
		quantity = 1;
	}
	if (quantity > goods.stock.integerValue) {
		[self displayHUDTitle:nil message:[NSString stringWithFormat:@"最大数量%@", goods.stock] duration:0.5];
		quantity = goods.stock.integerValue;
	}
	
//	if (quantity >= 100000) {
//		[self displayHUDTitle:nil message:@"请填写合理数量"];
//		quantity = 99999;
//	}
	
	textField.text = [NSString stringWithFormat:@"%@", @(quantity)];
	goods.quantityInCart = @(quantity);
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
	frame.origin.x = 7;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_editing) {
		return;
	}
	MLCartStore *cartStore = _cartStores[indexPath.section];
	MLGoods *goods = cartStore.multiGoods[indexPath.row];
	if (!goods.isOnSale.boolValue) {
		return;
	}
	MLGoodsDetailsViewController *controller = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
	controller.goods = goods;
	[self.navigationController pushViewController:controller animated:YES];
	
}


@end
