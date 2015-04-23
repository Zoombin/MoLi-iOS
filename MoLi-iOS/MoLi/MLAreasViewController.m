//
//  MLPickAreaViewController.m
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAreasViewController.h"
#import "Header.h"

@interface MLAreasViewController () <MLAreasViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *cities;

@end

@implementation MLAreasViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	if (_city) {
		self.title = @"选择区域";
	} else if (_province) {
		self.title = @"选择城市";
	} else {
		self.title = @"选择省份";
	}
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	if (_province) {
		[self displayHUD:@"加载中..."];
		[[MLAPIClient shared] areasInProvince:_province.ID withBlock:^(NSArray *multiAttributes, NSString *message, NSError *error) {
			if (!error) {
				if (message.length) {
					[self displayHUDTitle:nil message:message];
				} else {
					[self hideHUD:YES];
				}
				_cities = [MLCity multiWithAttributesArray:multiAttributes];
				[_tableView reloadData];
			} else {
				[self displayHUDTitle:nil message:[error MLErrorDesc]];
			}
		}];
	}
}

#pragma mark - MLAreasViewControllerDelegate

- (void)pickProvince:(MLProvince *)province city:(MLCity *)city area:(MLArea *)area {
	if (_delegate) {
		[_delegate pickProvince:_province city:city area:area];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_province) {
		return _cities.count;
	}
	return _city.areas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	}
	if (_province) {
		MLCity *city = _cities[indexPath.row];
		cell.textLabel.text = city.name;
	} else {
		MLArea *area = _city.areas[indexPath.row];
		cell.textLabel.text = area.name;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (_city) {
		MLArea *area = _city.areas[indexPath.row];
		if (_delegate) {
			[_delegate pickProvince:_province city:_city area:area];
			[self.navigationController popToRootViewControllerAnimated:YES];
			return;
		}
	}
	
	MLCity *city = _cities[indexPath.row];
	MLAreasViewController *areasViewController = [[MLAreasViewController alloc] initWithNibName:nil bundle:nil];
	areasViewController.delegate = self;
	areasViewController.city = city;
	[self.navigationController pushViewController:areasViewController animated:YES];
}

@end
