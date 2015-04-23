//
//  MLAboutViewController.m
//  MoLi
//
//  Created by zhangbin on 1/24/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAboutViewController.h"
#import "MLWebViewController.h"
#import "Header.h"
#import "MLAppInfo.h"

@interface MLAboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) MLAppInfo *appInfo;

@end;

@implementation MLAboutViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"关于我们";
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
    
    [self loadAppInfo];
}

- (void)loadAppInfo {
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] appsInfoWithBlock:^(NSDictionary *attributes, NSError *error) {
        [self hideHUD:YES];
        if (!error) {
            _appInfo = [[MLAppInfo alloc] initWithAttributes:attributes];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	
	CGRect rect = CGRectMake(tableView.separatorInset.left, 12, 64, 64);
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
	imageView.image = [UIImage imageNamed:@"Icon60"];
	imageView.clipsToBounds = YES;
	imageView.layer.cornerRadius = 10;
	[view addSubview:imageView];
	
	rect.origin.x = CGRectGetMaxX(imageView.frame) + 10;
	rect.origin.y = 15;
	rect.size.width = tableView.bounds.size.width - rect.origin.x;
	rect.size.height = 40;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = @"魔力网 For iOS";
	label.font = [UIFont systemFontOfSize:16];
	label.textColor = [UIColor fontGrayColor];
	[view addSubview:label];
	
	rect.origin.y = CGRectGetMaxY(label.frame) - 10;
	rect.size.height = 30;
	UILabel *versionLabel = [[UILabel alloc] initWithFrame:rect];
	versionLabel.font = [UIFont systemFontOfSize:13];
	versionLabel.textColor = [UIColor fontGrayColor];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	versionLabel.text = [NSString stringWithFormat:@"V%@", version];
	[view addSubview:versionLabel];
	
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 86;
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
	NSString *string = nil;
	if (indexPath.row == 0) {
		string = @"版权信息";
	} else if (indexPath.row == 1) {
		string = @"软件使用许可协议";
	} else if (indexPath.row == 2) {
		string = @"说明";
	}
	cell.textLabel.text = string;
	cell.textLabel.textColor = [UIColor fontGrayColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_appInfo == nil) {
        return;
    }
    MLWebViewController *webViewCtrl = [MLWebViewController new];
    [webViewCtrl setLeftBarButtonItemAsBackArrowButton];
    if (indexPath.row == 0) {
        webViewCtrl.title = @"版权信息";
        webViewCtrl.URLString = _appInfo.copyright;
    } else if (indexPath.row == 1) {
        webViewCtrl.title = @"软件使用许可协议";
        webViewCtrl.URLString = _appInfo.protocol;
    } else if (indexPath.row == 2) {
        webViewCtrl.title = @"说明";
        
        webViewCtrl.URLString = [[MLAPIClient shared] versiondescUrl].absoluteString;
    }
    [self.navigationController pushViewController:webViewCtrl animated:YES];
}

@end
