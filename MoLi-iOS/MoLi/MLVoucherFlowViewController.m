//
//  MLVoucherFlowViewController.m
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherFlowViewController.h"
#import "Header.h"
#import "MLVoucherFlow.h"
#import "ZBBottomIndexView.h"
#import "MLVoucherFlowTableViewCell.h"

@interface MLVoucherFlowViewController () <
ZBBottomIndexViewDelegate,
UITableViewDataSource, UITableViewDelegate
>

@property (readwrite) ZBBottomIndexView *bottomIndexView;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *multiVoucherFlow;
@property (readwrite) NSInteger page;
@property (readwrite) MLVoucherFlowType voucherFlowType;

@end

@implementation MLVoucherFlowViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"代金券使用明细";
	self.view.backgroundColor = [UIColor backgroundColor];
	
	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38)];
	[_bottomIndexView setItems:@[@"全部", @"获得", @"消费"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	_tableView.tableHeaderView = _bottomIndexView;
	
	_page = 1;
	
	[self.view addGestureRecognizer:[_bottomIndexView leftSwipeGestureRecognizer]];
	[self.view addGestureRecognizer:[_bottomIndexView rightSwipeGestureRecognizer]];
	
	_voucherFlowType = MLVoucherFlowTypeAll;
	[self fetchVoucherFlow];
}

- (void)fetchVoucherFlow {
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] voucherFlowWithType:_voucherFlowType page:@(_page) withBlock:^(NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_multiVoucherFlow = [MLVoucherFlow multiWithAttributesArray:multiAttributes];
		}
		[_tableView reloadData];
	}];
}

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex {
	if (selectedIndex == 0) {
		_voucherFlowType = MLVoucherFlowTypeAll;
	} else if (selectedIndex == 1) {
		_voucherFlowType = MLVoucherFlowTypeGet;
	} else if (selectedIndex == 2) {
		_voucherFlowType = MLVoucherFlowTypeUse;
	}
	[self fetchVoucherFlow];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLVoucherFlowTableViewCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _multiVoucherFlow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLVoucherFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLVoucherFlowTableViewCell identifier]];
	if (!cell) {
		cell = [[MLVoucherFlowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLVoucherFlowTableViewCell identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	MLVoucherFlow *voucherFlow = _multiVoucherFlow[indexPath.section];
	cell.voucherFlow = voucherFlow;
	return cell;
}



@end
