//
//  MLServicesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLServicesViewController.h"
#import "Header.h"
#import "MLOfficialPhone.h"
#import "MLAfterSalesServiceViewController.h"

static CGFloat const heightOfCell = 50;

@interface MLServicesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tabelView;

@end

@implementation MLServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"服务", nil);
	
	_tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tabelView.dataSource = self;
	_tabelView.delegate = self;
	[self.view addSubview:_tabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return heightOfCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.textLabel.textColor = [UIColor fontGrayColor];
	if (indexPath.section == 0) {
		cell.textLabel.text = NSLocalizedString(@"售后服务", nil);
	} else {
		cell.textLabel.text = NSLocalizedString(@"客服热线", nil);
		UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 0, tableView.frame.size.width - 86, heightOfCell)];
		phoneLabel.text = [MLOfficialPhone officialPhone];
		phoneLabel.font = [UIFont systemFontOfSize:20];
		phoneLabel.textColor = [UIColor themeColor];
		[cell addSubview:phoneLabel];
		
		UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Phone"]];
		cell.accessoryView = icon;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		MLAfterSalesServiceViewController *afterSalesServiceViewController = [[MLAfterSalesServiceViewController alloc] initWithNibName:nil bundle:nil];
        [afterSalesServiceViewController setLeftBarButtonItemAsBackArrowButton];
		[self.navigationController pushViewController:afterSalesServiceViewController animated:YES];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [MLOfficialPhone officialPhone]]]];
	}
}

@end
