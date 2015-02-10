//
//  MLSecurityViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLSecurityViewController.h"
#import "Header.h"
#import "MLAddressesViewController.h"
#import "MLChangePasswordViewController.h"
#import "MLWalletPasswordViewController.h"

@interface MLSecurityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;

@end

@implementation MLSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"账户与安全", nil);
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.textLabel.textColor = [UIColor fontGrayColor];
	if (indexPath.row == 0) {
		cell.textLabel.text = NSLocalizedString(@"收货地址", nil);
	} else if (indexPath.row == 1) {
		cell.textLabel.text = NSLocalizedString(@"登录密码修改", nil);
	} else {
		cell.textLabel.text = NSLocalizedString(@"交易密码", nil);
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0) {
		MLAddressesViewController *addressesViewController = [[MLAddressesViewController alloc] initWithNibName:nil bundle:nil];
		addressesViewController.hidesBottomBarWhenPushed = YES;
        [addressesViewController setLeftBarButtonItemAsBackArrowButton];
		[self.navigationController pushViewController:addressesViewController animated:YES];
	} else if (indexPath.row == 1) {
		MLChangePasswordViewController *changePasswordViewController = [[MLChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:changePasswordViewController animated:YES];
	} else {
		MLWalletPasswordViewController *walletPasswordViewController = [[MLWalletPasswordViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:walletPasswordViewController animated:YES];
	}
}

@end
