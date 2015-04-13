//
//  MLPaymentViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLPaymentViewController.h"
#import "ZBPaymentManager.h"
#import "Header.h"
#import "MLPayResultViewController.h"

@interface MLPaymentViewController () <UITableViewDataSource, UITableViewDelegate, MLPayResultViewControllerDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) ZBPaymentType selectedPaymentType;

@end

@implementation MLPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"魔力收银台", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPaymentResult:) name:ZBPAYMENT_NOTIFICATION_AFTER_PAY_IDENTIFIER object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ZBPAYMENT_NOTIFICATION_AFTER_PAY_IDENTIFIER object:nil];
}

- (void)receivedPaymentResult:(NSNotification *)notification {
	NSDictionary *dictionary = notification.userInfo;
	MLPayResultViewController *controller = [[MLPayResultViewController alloc] initWithNibName:nil bundle:nil];
	controller.delegate = self;
	controller.success = [dictionary[ZBPaymentKeySuccess] boolValue];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)payWithPaymentType:(ZBPaymentType)type {
	NSString *priceString = [NSString stringWithFormat:@"%@", _payment.payAmount];
#warning TODO hardcode price to test payment
	priceString = @"0.01";
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] callbackOfPaymentID:_payment.ID paymentType:type withBlock:^(NSString *callbackURLString, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[[ZBPaymentManager shared] pay:type price:priceString orderID:_payment.ID name:_payment.paySubject description:_payment.payBody callbackURLString:callbackURLString withBlock:^(BOOL success) {
				if (success) {
					NSLog(@"成功");
				} else {
					NSLog(@"失败");
				}
			}];
		}
	}];
}

#pragma mark - MLPayResultViewControllerDelegate

- (void)repay {
	[self payWithPaymentType:_selectedPaymentType];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.separatorInset.left, 10, tableView.bounds.size.width - 2 * tableView.separatorInset.left, 45 - 10)];
	label.text = NSLocalizedString(@"请选择支付方式", nil);
	label.textColor = [UIColor fontGrayColor];
	label.font = [UIFont systemFontOfSize:16];
	[view addSubview:label];
	
	UILabel *priceLabel = [[UILabel alloc] initWithFrame:label.frame];
	priceLabel.textColor = [UIColor themeColor];
	priceLabel.textAlignment = NSTextAlignmentRight;
	priceLabel.font = [UIFont systemFontOfSize:16];
	priceLabel.text = [NSString stringWithFormat:@"¥%@", _payment.payAmount];
	[view addSubview:priceLabel];
	return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	}
	if (indexPath.row == 0) {
		cell.imageView.image = [UIImage imageNamed:@"WeChat"];
		cell.textLabel.text = NSLocalizedString(@"微信支付", nil);
	} else {
		cell.imageView.image = [UIImage imageNamed:@"Alipay"];
		cell.textLabel.text = NSLocalizedString(@"支付宝支付", nil);
	}
	cell.textLabel.textColor = [UIColor fontGrayColor];
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	_selectedPaymentType = ZBPaymentTypeAlipay;
    if (indexPath.row == 0) {
        _selectedPaymentType = ZBPaymentTypeWeixin;
    }
	[self payWithPaymentType:_selectedPaymentType];
}

@end
