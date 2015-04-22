//
//  MLVoucherViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLVoucherViewController.h"
#import "Header.h"
#import "MLNewVoucherViewController.h"
#import "MLVoucherFlowViewController.h"

@interface MLVoucherViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UILabel *moneyLabel;
@property (readwrite) UILabel *titleLabel;
@property (readwrite) UILabel *titleLabel2;
@property (readwrite) UIView *voucherView;
@property (readwrite) UIView *detailsView;
@property (readwrite) BOOL showDetails;

@end

@implementation MLVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"代金券", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.separatorInset = UIEdgeInsetsZero;
	[self.view addSubview:_tableView];
	
	_voucherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
	_voucherView.backgroundColor = [UIColor themeColor];
	
	UIImageView *voucherBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VoucherBottom"]];
	voucherBottom.frame = CGRectMake(0, 170 - 2.5, self.view.bounds.size.width, 2.5);
	[_voucherView addSubview:voucherBottom];
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _voucherView.frame.size.width, 20)];
	_titleLabel.font = [UIFont systemFontOfSize:14];
	_titleLabel.textColor = [UIColor whiteColor];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.text = @"代金券总金额（元）";
	[_voucherView addSubview:_titleLabel];
	
	_moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), _voucherView.frame.size.width, 100)];
	_moneyLabel.font = [UIFont systemFontOfSize:56];
	_moneyLabel.textColor = [UIColor whiteColor];
	_moneyLabel.textAlignment = NSTextAlignmentCenter;
	[_voucherView addSubview:_moneyLabel];
	
	UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(voucherBottom.frame), self.view.bounds.size.width, 50)];
	subtitleLabel.text = @"点击翻开查看使用细则";
	subtitleLabel.font = [UIFont systemFontOfSize:10];
	subtitleLabel.textAlignment = NSTextAlignmentCenter;
	subtitleLabel.backgroundColor = [UIColor whiteColor];
	subtitleLabel.userInteractionEnabled = YES;
	[_voucherView addSubview:subtitleLabel];
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subtitleLabel.frame) - 0.5, self.view.bounds.size.width, 0.5)];
	line.backgroundColor = [UIColor lightGrayColor];
	[_voucherView addSubview:line];
	
	_detailsView = [[UIView alloc] initWithFrame:_voucherView.frame];
	_detailsView.backgroundColor = [UIColor colorWithRed:29/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
	
	_titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _voucherView.frame.size.width, 20)];
	_titleLabel2.font = [UIFont systemFontOfSize:14];
	_titleLabel2.textColor = [UIColor whiteColor];
	_titleLabel2.textAlignment = NSTextAlignmentCenter;
	_titleLabel2.text = @"代金券使用细则";
	[_detailsView addSubview:_titleLabel2];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 20, CGRectGetWidth(_detailsView.frame) - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, CGRectGetHeight(_detailsView.frame) - 58)];
	label.numberOfLines = 0;
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont systemFontOfSize:13];
	label.text = [MLGlobal shared].voucherterm;//@"① 购买赠代金券的商品，确认收货后可领取代金券\n② 领取代金券的订单不可申请退换货\n③ 代金券不可兑现，代金券支付的部分不开发票\n④ 代金券最终解释权归江苏魔力网络科技有限公司所有";
	[_detailsView addSubview:label];
	
	UILabel *subtitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(voucherBottom.frame), self.view.bounds.size.width, 50)];
	subtitleLabel2.text = @"点击翻开查看代金券余额";
	subtitleLabel2.font = [UIFont systemFontOfSize:10];
	subtitleLabel2.textAlignment = NSTextAlignmentCenter;
	subtitleLabel2.backgroundColor = [UIColor whiteColor];
	subtitleLabel2.userInteractionEnabled = YES;
	[_detailsView addSubview:subtitleLabel2];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subtitleLabel2.frame) - 0.5, self.view.bounds.size.width, 0.5)];
	line2.backgroundColor = [UIColor lightGrayColor];
	[_detailsView addSubview:line2];
	
	_tableView.tableHeaderView = _voucherView;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHeaderView)];
	[_voucherView addGestureRecognizer:tap];
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHeaderView)];
	[_detailsView addGestureRecognizer:tap2];
}

- (void)viewDidAppear:(BOOL)animated {
	[[MLAPIClient shared] myVoucherWithBlock:^(NSNumber *voucherValue, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_moneyLabel.text = [NSString stringWithFormat:@"%@", voucherValue];
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tappedHeaderView {
	_showDetails = !_showDetails;
	if (_showDetails) {
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
			_voucherView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1.0, 0.0);
		} completion:^(BOOL finished) {
			_tableView.tableHeaderView = _detailsView;
			[_tableView reloadData];
			_voucherView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 0.0);
		}];
	} else {
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
			_detailsView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1.0, 0.0);
		} completion:^(BOOL finished) {
			_tableView.tableHeaderView = _voucherView;
			[_tableView reloadData];
			_detailsView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0.0, 0.0);
		}];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.textLabel.textColor = [UIColor fontGrayColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	if (indexPath.row == 0) {
		cell.textLabel.text = @"领取代金券";
	} else {
		cell.textLabel.text = @"代金券使用明细";
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		MLNewVoucherViewController *newVoucherViewController = [[MLNewVoucherViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:newVoucherViewController animated:YES];
	} else if (indexPath.row == 1) {
		MLVoucherFlowViewController *voucherFlowViewController = [[MLVoucherFlowViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:voucherFlowViewController animated:YES];		
	}
}

@end
