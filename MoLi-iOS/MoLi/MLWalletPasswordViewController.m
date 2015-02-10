//
//  MLWalletPasswordViewController.m
//  MoLi
//
//  Created by zhangbin on 2/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLWalletPasswordViewController.h"
#import "Header.h"
#import "MLSetWalletPasswordViewController.h"
#import "MLChangePasswordViewController.h"
#import "MLVerifyCodeViewController.h"

@interface MLWalletPasswordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSNumber *hasWalletPassword;

@end

@implementation MLWalletPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"交易密码";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.separatorInset = UIEdgeInsetsZero;
	[self.view addSubview:_tableView];

}

- (void)viewDidAppear:(BOOL)animated {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] userHasWalletPasswordWithBlock:^(NSNumber *hasWalletPassword, MLResponse *response) {
		if (response.message) {
			[self displayHUDTitle:nil message:response.message];
		} else {
			[self hideHUD:YES];
		}
		if (response.success) {
			_hasWalletPassword = hasWalletPassword;
			[_tableView reloadData];
		}
	}];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_hasWalletPassword) {
		if (_hasWalletPassword.boolValue) {
			return 2;
		} else {
			return 1;
		}
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSArray *array = nil;
	if (_hasWalletPassword.boolValue) {
		array = @[@"修改交易密码", @"找回交易密码"];
	} else {
		array = @[@"设置交易密码"];
	}
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.textLabel.textColor = [UIColor fontGrayColor];
	cell.textLabel.text = array[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_hasWalletPassword.boolValue) {
		if (indexPath.row == 0) {
			MLChangePasswordViewController *changePasswordViewController = [[MLChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
			changePasswordViewController.isWalletPassword = YES;
			[self.navigationController pushViewController:changePasswordViewController animated:YES];
		} else {
			MLVerifyCodeViewController *verifyCodeViewController = [[MLVerifyCodeViewController alloc] initWithNibName:nil bundle:nil];
			verifyCodeViewController.type = MLVerifyCodeTypeForgotWalletPassword;
			[self presentViewController:[[UINavigationController alloc] initWithRootViewController:verifyCodeViewController] animated:YES completion:nil];
		}
	} else {
		MLSetWalletPasswordViewController *setWalletPasswordViewController = [[MLSetWalletPasswordViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:setWalletPasswordViewController animated:YES];
	}
}

@end
