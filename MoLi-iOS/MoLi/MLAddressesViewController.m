//
//  MLAddressesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLAddressesViewController.h"
#import "Header.h"
#import "MLEditAddressViewController.h"
#import "MLAddressTableViewCell.h"
#import "MLEditAddressViewController.h"
#import "MLNoDataView.h"

@interface MLAddressesViewController () <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, MLAddressTableViewCellDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *addresses;
@property (readwrite) MLAddress *selectedAddress;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLAddressesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"收货地址", nil);
	
	CGFloat bannerHeight = 50;
	CGRect frame = CGRectMake(0, self.view.bounds.size.height - bannerHeight, self.view.bounds.size.width, bannerHeight);
	
	UIButton *addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
	addNewAddressButton.frame = frame;
	[addNewAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
	addNewAddressButton.showsTouchWhenHighlighted = YES;
	addNewAddressButton.backgroundColor = [UIColor themeColor];
	[addNewAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[addNewAddressButton addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:addNewAddressButton];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - bannerHeight - 64) style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoAddress"];
	_noDataView.label.text = @"您还没有收货地址";
	_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self fetchAddresses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchAddresses {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] addressesWithBlock:^(NSArray *multiAttributes, NSString *message, NSError *error) {
		if (!error) {
			[self hideHUD:YES];
			_addresses = [MLAddress multiWithAttributesArray:multiAttributes];
			_noDataView.hidden = _addresses.count ? YES : NO;
			[_tableView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

- (void)addNewAddress {
	MLEditAddressViewController *editAddressViewController = [[MLEditAddressViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:editAddressViewController animated:YES];
}

#pragma mark - UIAddressTableViewDelegate

- (void)setDefaultAddress:(MLAddress *)address {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] setDefaultAddress:address.ID withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[self fetchAddresses];
		}
	}];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		if (buttonIndex == 0) {//编辑
			MLEditAddressViewController *editAddressViewController = [[MLEditAddressViewController alloc] initWithNibName:nil bundle:nil];
			editAddressViewController.address = _selectedAddress;
			[self.navigationController pushViewController:editAddressViewController animated:YES];
		} else if (buttonIndex == 1) {//删除
			[self displayHUD:@"加载中..."];
			[[MLAPIClient shared] deleteAddress:_selectedAddress.ID withBlock:^(MLResponse *response) {
				[self displayResponseMessage:response];
				if (response.success) {
					[self fetchAddresses];
				}
			}];
		}
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _addresses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLAddressTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLAddressTableViewCell identifier]];
	if (!cell) {
		cell = [[MLAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLAddressTableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	MLAddress *address = _addresses[indexPath.section];
	cell.address = address;
	cell.indexPath = indexPath;
	cell.delegate = self;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MLAddress *address = _addresses[indexPath.section];
	_selectedAddress = address;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"功能" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"删除", nil];
	[actionSheet showInView:self.view];
}

@end
