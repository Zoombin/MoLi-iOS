//
//  MLPrepareOrderViewController.m
//  MoLi
//
//  Created by zhangbin on 1/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLPrepareOrderViewController.h"
#import "Header.h"
#import "MLAddress.h"
#import "MLAddAddressTableViewCell.h"
#import "MLAddressTableViewCell.h"
#import "MLEditAddressViewController.h"
#import "MLSubmitOrderTableViewCell.h"
#import "MLVoucherTableViewCell.h"
#import "MLUseVoucherTableViewCell.h"
#import "MLGoodsTableViewCell.h"
#import "MLVoucher.h"
#import "MLPaymentViewController.h"
#import "MLOrderResult.h"
#import "MLCommentFooter.h"
#import "MLAddressesViewController.h"

@interface MLPrepareOrderViewController () <
UIAlertViewDelegate,
MLSubmitOrderTableViewCellDelegate,
UITableViewDataSource, UITableViewDelegate
>

@property (readwrite) UITableView *tableView;
//@property (readwrite) UIView *submitView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) NSArray *cartStores;
@property (readwrite) MLAddress *address;
@property (readwrite) NSNumber *totalPrice;
@property (readwrite) MLVoucher *voucher;
@property (readwrite) BOOL useVoucher;
@property (readwrite) UIAlertView *alertView;
@property (readwrite) NSString *password;

@end

@implementation MLPrepareOrderViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"填写订单";
	[self setLeftBarButtonItemAsBackArrowButton];
	
//	CGFloat heightForSubmitView = 50;
//	CGRect rect = CGRectZero;
//	rect.size.width = self.view.bounds.size.width;
//	rect.size.height = heightForSubmitView;
//	_submitView = [[UIView alloc] initWithFrame:rect];
//	_submitView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
//	[self.view addSubview:_submitView];
//	
//	rect.origin.x = 15;
//	rect.origin.y = 25;
//	rect.size.height = 25;
//	UILabel *label = [[UILabel alloc] initWithFrame:rect];
//	label.text = @"总价金额";
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[MLAPIClient shared] prepareOrder:_multiGoods buyNow:NO withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_totalPrice = totalPrice;
			
			NSMutableArray *tmp = [NSMutableArray array];
			
			if ([addressAttributes notNull].count) {
				_address = [[MLAddress alloc] initWithAttributes:addressAttributes];
				[tmp addObject:[MLAddressTableViewCell class]];
			} else {
				[tmp addObject:[MLAddAddressTableViewCell class]];
			}
			
			if ([multiGoods notNull].count) {
				_cartStores = [MLCartStore multiWithAttributesArray:multiGoods];
				for (int i = 0; i < _cartStores.count; i++) {
					[tmp addObject:[MLGoodsTableViewCell class]];
				}
			}
			
			_voucher = [[MLVoucher alloc] initWithAttributes:voucherAttributes];
			//if (_voucher.voucherWillGet.integerValue > 0) {
				[tmp addObject:[MLVoucherTableViewCell class]];
			//}
			
			if (_voucher.voucherCanCost.integerValue > 0) {
				[tmp addObject:[MLUseVoucherTableViewCell class]];
			}
			
			[tmp addObject:[MLSubmitOrderTableViewCell class]];
			
			_sectionClasses = [NSArray arrayWithArray:tmp];
			
			[_tableView reloadData];
		}
	}];
}

- (void)saveOrder {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] saveOrder:_cartStores buyNow:NO address:_address.ID voucher:_voucher walletPassword:_password withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLOrderResult *orderResult = [[MLOrderResult alloc] initWithAttributes:attributes];
			MLPaymentViewController *paymentViewController = [[MLPaymentViewController alloc] initWithNibName:nil bundle:nil];
			paymentViewController.orderResult = orderResult;
			paymentViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:paymentViewController animated:YES];
		}
	}];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		UITextField *textField = [alertView textFieldAtIndex:0];
		if (!textField.text.length) {
			[self displayHUDTitle:nil message:@"请输入支付密码"];
			return;
		}
		_password = textField.text;
		[self saveOrder];
	}
}

#pragma mark - MLSubmitTableViewCellDelegate

- (void)submitOrder {
	if (_useVoucher) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单确认" message:@"请输入支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		alert.alertViewStyle = UIAlertViewStylePlainTextInput;
		UITextField *textField = [alert textFieldAtIndex:0];
		textField.secureTextEntry = YES;
		[alert show];
	} else {
		[self saveOrder];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsTableViewCell class]) {
		return [MLCommentFooter height];
	}
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	return [class height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsTableViewCell class]) {
		MLCommentFooter *commentFooter = [[MLCommentFooter alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [MLCommentFooter height])];
		MLCartStore *cartStore = _cartStores[section - 1];
		commentFooter.cartStore = cartStore;
		return commentFooter;
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sectionClasses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsTableViewCell class]) {
		if (_cartStores.count) {
			MLCartStore *cartStore = _cartStores[section - 1];
			return cartStore.multiGoods.count;
		}
		return 0;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[class identifier]];
	if (!cell) {
		cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[class identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (class == [MLAddressTableViewCell class]) {
		MLAddressTableViewCell *addressCell = (MLAddressTableViewCell *)cell;
		addressCell.address = _address;
		addressCell.indexPath = indexPath;
        [addressCell setDefaultAddressCellState];
        addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (class == [MLGoodsTableViewCell class]) {
		MLGoodsTableViewCell *goodsCell = (MLGoodsTableViewCell *)cell;
		MLCartStore *cartStore = _cartStores[indexPath.section - 1];
		MLGoods *goods = cartStore.multiGoods[indexPath.row];
		goodsCell.goods = goods;
		goodsCell.cartMode = YES;
	} else if (class == [MLVoucherTableViewCell class]) {
		MLVoucherTableViewCell *voucherCell = (MLVoucherTableViewCell *)cell;
		voucherCell.voucher = _voucher;
	} else if (class == [MLUseVoucherTableViewCell class]) {
		MLUseVoucherTableViewCell *voucherCell = (MLUseVoucherTableViewCell *)cell;
		voucherCell.voucher = _voucher;
		voucherCell.selectedVoucher = _useVoucher;
	} else if (class == [MLSubmitOrderTableViewCell class]) {
		MLSubmitOrderTableViewCell *submitCell = (MLSubmitOrderTableViewCell *)cell;
		submitCell.delegate = self;
		submitCell.price = _totalPrice;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLAddressTableViewCell class]) {
        MLAddressesViewController *addrViewController = [[MLAddressesViewController alloc] initWithNibName:nil bundle:nil];
        addrViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addrViewController animated:YES];
        
//		MLEditAddressViewController *editAddressViewController = [[MLEditAddressViewController alloc] initWithNibName:nil bundle:nil];
//		editAddressViewController.hidesBottomBarWhenPushed = YES;
//		[self.navigationController pushViewController:editAddressViewController animated:YES];
	} else if (class == [MLVoucherTableViewCell class]) {
		//TODO:
        MLVoucherTableViewCell *voucherCell = (MLVoucherTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        voucherCell.isVoucherDetail = !voucherCell.isVoucherDetail;
        [voucherCell showDetail];
	} else if (class == [MLUseVoucherTableViewCell class]) {
		_useVoucher = !_useVoucher;
		[_tableView reloadData];
	}
}

@end
