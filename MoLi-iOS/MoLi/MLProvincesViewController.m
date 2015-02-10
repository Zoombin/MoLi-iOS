//
//  MLPickProvinceViewController.m
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLProvincesViewController.h"
#import "Header.h"
#import "MLAreasViewController.h"

@interface MLProvincesViewController () <UITableViewDataSource, UITableViewDelegate, MLAreasViewControllerDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *provinces;

@end

@implementation MLProvincesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"选择省份";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] provincesWithBlock:^(NSArray *multiAttributes, NSString *message, NSError *error) {
		if (!error) {
			if (message.length) {
				[self displayHUDTitle:nil message:message];
			} else {
				[self hideHUD:YES];
			}
			_provinces = [MLProvince multiWithAttributesArray:multiAttributes];
			[_tableView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

- (void)back {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MLAreasViewControllerDelegate

- (void)pickProvince:(MLProvince *)province city:(MLCity *)city area:(MLArea *)area {
	if (_delegate) {
		[_delegate pickProvince:province city:city area:area];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	}
	MLProvince *province = _provinces[indexPath.row];
	cell.textLabel.text = province.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MLAreasViewController *areasViewController = [[MLAreasViewController alloc] initWithNibName:nil bundle:nil];
	MLProvince *province = _provinces[indexPath.row];
	areasViewController.province = province;
	areasViewController.delegate = self;
	[self.navigationController pushViewController:areasViewController animated:YES];
}
@end
