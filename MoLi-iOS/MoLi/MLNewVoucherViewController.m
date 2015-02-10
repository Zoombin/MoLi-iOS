//
//  MLNewVoucherViewController.m
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLNewVoucherViewController.h"
#import "Header.h"
#import "MLVoucher.h"
#import "MLNewVoucherTableViewCell.h"
#import "MLNoDataView.h"

@interface MLNewVoucherViewController () <
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate
>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *multiVoucher;
@property (readwrite) NSInteger page;
@property (readwrite) MLVoucher *selectedVoucher;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLNewVoucherViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"领取代金券";
	self.view.backgroundColor = [UIColor backgroundColor];
	_page = 1;
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoVoucher"];
	_noDataView.label.text = @"亲，您还没有代金券哦";
	[self.view addSubview:_noDataView];
	
	[self fetchMultiVoucher];
}

- (void)fetchMultiVoucher {
	[[MLAPIClient shared] newVoucherPage:@(_page) withBlock:^(NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_multiVoucher = [MLVoucher multiWithAttributesArray:multiAttributes];
			_noDataView.hidden = _multiVoucher.count ? YES : NO;
			[_tableView reloadData];
		}
	}];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		[[MLAPIClient shared] takeVoucher:_selectedVoucher withBlock:^(MLResponse *response) {
			[self displayResponseMessage:response];
			[self fetchMultiVoucher];
		}];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLNewVoucherTableViewCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _multiVoucher.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLNewVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLNewVoucherTableViewCell identifier]];
	if (!cell) {
		cell = [[MLNewVoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLNewVoucherTableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	MLVoucher *voucher = _multiVoucher[indexPath.section];
	cell.voucher = voucher;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MLVoucher *voucher = _multiVoucher[indexPath.section];
	_selectedVoucher = voucher;
	NSString *title = [NSString stringWithFormat:@"可领取%@元", _selectedVoucher.value];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"领取后不可退换，是否确认领取？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认领取", nil];
	[alert show];
}
@end
