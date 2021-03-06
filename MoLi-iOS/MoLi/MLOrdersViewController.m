//
//  MLOrdersViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLOrdersViewController.h"
#import "Header.h"
#import "ZBBottomIndexView.h"
#import "MLOrder.h"
#import "MLGoodsOrderTableViewCell.h"
#import "MLOrderFooterView.h"
#import "MLLogisticViewController.h"
#import "MLLogistic.h"
#import "MLPaymentViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLOrderDetailViewController.h"
#import "MLNoDataView.h"
#import "MLJudgeViewController.h"
#import "MLSetWalletPasswordViewController.h"

@interface MLOrdersViewController () <
MLOrderFooterViewDelegate,
ZBBottomIndexViewDelegate,
UITableViewDataSource, UITableViewDelegate,
UIAlertViewDelegate
>

@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *orders;
@property (readwrite) NSInteger page;
@property (readwrite) MLNoDataView *noDataView;
@property (readwrite) MLOrder *currentOrder;
@property (readwrite) MLOrderOperator *currentOrderOperator;

@end

@implementation MLOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"全部订单", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_page = 1;
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, self.view.bounds.size.width, self.view.bounds.size.height - 32) style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];
	
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
	[_bottomIndexView setItems:@[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
	[self.view addSubview:_bottomIndexView];
	
	[_bottomIndexView setSelectedIndex:_status];
	[self fetchOrders:_status];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height - 120)];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoOrder"];
	_noDataView.label.text = @"您还没有订单";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
	
	[self.view addGestureRecognizer:[_bottomIndexView leftSwipeGestureRecognizer]];
	[self.view addGestureRecognizer:[_bottomIndexView rightSwipeGestureRecognizer]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:ML_GOODS_TAKE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleNotify:(NSNotification *)notify
{
    [self fetchOrders:_status];
}

- (void)fetchOrders:(MLOrderStatus)status {
	[[MLAPIClient shared] orders:[MLOrder identifierForStatus:status] page:@(_page) withBlock:^(NSArray *multiAttributes, NSString *message, NSError *error) {
		if (!error) {
			_orders = [MLOrder multiWithAttributesArray:multiAttributes];
			if (_orders.count) {
				_noDataView.hidden = YES;
			} else {
				_noDataView.hidden = NO;
			}
			[_tableView reloadData];
		} else {
			[self displayHUDTitle:nil message:[error MLErrorDesc]];
		}
	}];
}

- (void)goToShopping {
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - MLOrderFooterViewDelegate

- (void)executeOrder:(MLOrder *)order withOperator:(MLOrderOperator *)orderOpertor {
	_currentOrder = order;
	_currentOrderOperator = orderOpertor;
	if (orderOpertor.type == MLOrderOperatorTypePay) {
		[self displayHUD:@"加载中..."];
		[[MLAPIClient shared] payOrders:@[order.ID] withBlock:^(NSDictionary *attributes, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				MLPayment *payment = [[MLPayment alloc] initWithAttributes:attributes];
				MLPaymentViewController *controller = [[MLPaymentViewController alloc] initWithNibName:nil bundle:nil];
				controller.payment = payment;
				[self.navigationController pushViewController:controller animated:YES];
			}
		}];
		return;
	} else if (orderOpertor.type == MLOrderOperatorTypeConfirm) {
		[self displayHUD:@"加载中..."];
		[[MLAPIClient shared] userHasWalletPasswordWithBlock:^(NSNumber *hasWalletPassword, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				if (hasWalletPassword.boolValue) {
					NSString *message  = [NSString stringWithFormat:@"%.2f元", order.totalPrice.floatValue];
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认收货", nil];
					alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
					UITextField *textField = [alertView textFieldAtIndex:0];
					textField.secureTextEntry = YES;
					textField.placeholder = @"请输入交易密码";
					[alertView show];
				} else {
					MLSetWalletPasswordViewController *setWalletPasswordViewController = [[MLSetWalletPasswordViewController alloc] initWithNibName:nil bundle:nil];
					[self.navigationController pushViewController:setWalletPasswordViewController animated:YES];
				}
			}
		}];
		return;
	} else if (orderOpertor.type == MLOrderOperatorTypeVoucher) {
		Class class = [MLOrderOperator classForType:orderOpertor.type];
		if (class) {
			UIViewController *controller = [[class alloc] initWithNibName:nil bundle:nil];
			if (controller) {
				[self.navigationController pushViewController:controller animated:YES];
			}
		}
		return;
    } else if (orderOpertor.type == MLOrderOperatorTypeComment) {
        MLJudgeViewController *controller = [MLJudgeViewController new];
        controller.order = _currentOrder;
        [self.navigationController pushViewController:controller animated:YES];
    }
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] operateOrder:order orderOperator:orderOpertor afterSalesGoods:nil password:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			if (orderOpertor.type == MLOrderOperatorTypeNotice) {
				[self displayHUDTitle:nil message:@"提醒卖家发货成功" duration:2];//hardcode，应该服务器返回才对
				return;
			}
			if (orderOpertor.type == MLOrderOperatorTypeLogistic) {
				MLLogistic *logistic = [[MLLogistic alloc] initWithAttributes:attributes];
				MLLogisticViewController *logisticViewController = [[MLLogisticViewController alloc] initWithNibName:nil bundle:nil];
				logisticViewController.logistic = logistic;
				[self.navigationController pushViewController:logisticViewController animated:YES];
			} else {
				[self fetchOrders:_status];
			}
		}
	}];
}

#pragma mark - ZBBottomIndexViewDelegate

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
	_status = (MLOrderStatus)selectedIndex;
	[self fetchOrders:_status];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		UITextField *textField = [alertView textFieldAtIndex:0];
		if (!textField||!textField.text.length) {
			[self displayHUDTitle:nil message:@"请输入支付密码"];
			return;
		}
		NSString *password = textField.text;
		
		[[MLAPIClient shared] operateOrder:_currentOrder orderOperator:_currentOrderOperator afterSalesGoods:nil password:password withBlock:^(NSDictionary *attributes, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				[self fetchOrders:_status];
			}
		}];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [MLOrderFooterView height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLGoodsOrderTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	
	UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 14, tableView.bounds.size.width, 40)];
	banner.backgroundColor = [UIColor whiteColor];
	[view addSubview:banner];

	MLOrder *order = _orders[section];
	MLStore *store = order.store;
	
	CGRect frame = CGRectZero;
	UIImage *image = [UIImage imageNamed:@"OrderStore"];
	frame.origin.x = 15;
	frame.origin.y = 10;
	frame.size = image.size;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = frame;
	[banner addSubview:imageView];
	
	frame.origin.x = CGRectGetMaxX(imageView.frame) + 5;
	frame.size.width = tableView.bounds.size.width - frame.origin.x;
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = store.name;
	label.font = [UIFont systemFontOfSize:13];
	label.textColor = [UIColor fontGrayColor];
	[banner addSubview:label];

	frame.size.width = frame.size.width - 15;
	UILabel *priceLabel = [[UILabel alloc] initWithFrame:frame];
	priceLabel.text = [NSString stringWithFormat:@"¥%0.2f", [order.totalPrice floatValue]];
	priceLabel.textColor = [UIColor themeColor];
	priceLabel.font = [UIFont systemFontOfSize:17];
	priceLabel.textAlignment = NSTextAlignmentRight;
	[banner addSubview:priceLabel];
	return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	MLOrderFooterView *orderFooterView = [[MLOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [MLOrderFooterView height])];
	MLOrder *order = _orders[section];
	orderFooterView.order = order;
	orderFooterView.delegate = self;
	[view addSubview:orderFooterView];
	return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MLOrder *order = _orders[section];
	return order.multiGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLGoodsOrderTableViewCell identifier]];
	if (!cell) {
		cell = [[MLGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsOrderTableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	MLOrder *order = _orders[indexPath.section];
	MLGoods *goods = order.multiGoods[indexPath.row];
	cell.goods = goods;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MLOrder *order = _orders[indexPath.section];
    MLOrderDetailViewController *orderDetailViewController = [MLOrderDetailViewController new];
    orderDetailViewController.order = order;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}


@end
