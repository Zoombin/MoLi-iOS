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
	_page = 1;

	_bottomIndexView = [[ZBBottomIndexView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 38)];
	[_bottomIndexView setItems:@[@"全部", @"获得", @"消费"]];
	[_bottomIndexView setIndexColor:[UIColor themeColor]];
	[_bottomIndexView setTitleColor:[UIColor fontGrayColor]];
	[_bottomIndexView setTitleColorSelected:[UIColor themeColor]];
	_bottomIndexView.delegate = self;
	[_bottomIndexView setFont:[UIFont systemFontOfSize:15]];
	[self.view addSubview:_bottomIndexView];
	
	CGRect rect = self.view.bounds;
	rect.origin.y = CGRectGetMaxY(_bottomIndexView.frame);
	rect.size.height = self.view.bounds.size.height - rect.origin.y;
	_tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
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
			MLVoucherFlow *voucherFlow = [[MLVoucherFlow alloc] init];
			voucherFlow.action = @"购买新妖精的口袋ELSALe第五季冬装花边联机元将会获得代金券哦！";
			voucherFlow.amount = @"-5";
			
			MLVoucherFlow *voucherFlow2 = [[MLVoucherFlow alloc] init];
			voucherFlow2.action = @"购买新妖精的口袋ELSALe第五季冬装花边联机元将会获得代金券哦！";
			voucherFlow2.amount = @"-5";
#warning TODO TOTEST
			_multiVoucherFlow = @[voucherFlow, voucherFlow2];
//			_multiVoucherFlow = [MLVoucherFlow multiWithAttributesArray:multiAttributes];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
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
