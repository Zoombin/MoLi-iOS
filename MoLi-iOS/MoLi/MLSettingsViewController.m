//
//  MLSettingsViewController.m
//  MoLi
//
//  Created by zhangbin on 1/23/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLSettingsViewController.h"
#import "Header.h"
#import "MLSigninViewController.h"
#import "AppDelegate.h"
#import "MLAboutViewController.h"
#import "MLCache.h"

static NSString * const sectionTitle = @"sectionTitle";
static NSString * const sectionRows = @"sectionRows";
static NSString * const rowTitle = @"rowTitle";
static NSString * const rowIdentifier = @"rowIdentifier";
static NSString * const identifierAbout = @"identifierAbout";
static NSString * const identifierVersion = @"identifierVersion";
static NSString * const identifierShare = @"identifierShare";
static NSString * const identifierClearCache = @"identifierClearCache";
static NSString * const identifierSigninOrSignout = @"identifierSigninOrSignout";
static NSString * const accessory = @"accessory";
static NSString * const selector = @"selector";
static NSString * const userDefaultKey = @"userDefaultKey";
static NSString * const sectionHeaderHeight = @"sectionHeaderHeight";

@interface MLSettingsViewController () <
UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate
>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *sectionsData;

@end

@implementation MLSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"设置";
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];

	NSDictionary *section1Row1 = @{rowTitle : @"智能模式",
								   rowIdentifier : ML_USER_DEFAULT_NETWORKING_VALUE_AUTO,
								   userDefaultKey : ML_USER_DEFAULT_IDENTIFIER_NETWORKING
								   };
	NSDictionary *section1Row2 = @{rowTitle : @"高质量（适合WIFI环境）",
								   rowIdentifier : ML_USER_DEFAULT_NETWORKING_VALUE_WIFI,
								   userDefaultKey : ML_USER_DEFAULT_IDENTIFIER_NETWORKING
								   };
	NSDictionary *section1Row3 = @{rowTitle : @"普通质量（适合3G或2G环境）",
								   rowIdentifier : ML_USER_DEFAULT_NETWORKING_VALUE_3G,
								   userDefaultKey : ML_USER_DEFAULT_IDENTIFIER_NETWORKING
								   };
	NSDictionary *section1 = @{sectionTitle : @"图片显示质量", sectionRows : @[section1Row1, section1Row2, section1Row3]};
	
	NSDictionary *section2Row1 = @{rowTitle : @"接收推送消息",
								   rowIdentifier : ML_USER_DEFAULT_PUSH_VALUE,
								   userDefaultKey : ML_USER_DEFAULT_IDENTIFIER_PUSH
								   };
	NSDictionary *section2Row2 = @{rowTitle : @"声音提醒",
								   rowIdentifier : ML_USER_DEFAULT_PUSH_SOUND_VALUE,
								   userDefaultKey : ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND
								   };
	NSDictionary *section2 = @{sectionTitle : @"通知", sectionRows : @[section2Row1, section2Row2]};
	
	NSDictionary *section3Row1 = @{rowTitle : @"关于我们",
								   rowIdentifier : identifierAbout,
								   accessory : @(YES),
								   selector : NSStringFromSelector(@selector(about))
								   };
//	NSDictionary *section3Row2 = @{rowTitle : @"检查更新",
//								   rowIdentifier : identifierVersion,
//								   accessory : @(YES),
//								   selector : NSStringFromSelector(@selector(version))
//								   };
	NSDictionary *section3Row3 = @{rowTitle : @"分享APP",
								   rowIdentifier : identifierShare,
								   accessory : @(YES),
								   selector : NSStringFromSelector(@selector(share))
								   };
	
	NSDictionary *section3 = @{sectionTitle : @"魔力网", sectionRows : @[section3Row1, section3Row3]};
	
	NSDictionary *section4Row1 = @{rowTitle : @"清空缓存",
								   rowIdentifier : identifierClearCache,
								   accessory : @(NO),
								   selector : NSStringFromSelector(@selector(clearCache))
								   };
	NSDictionary *section4 = @{sectionRows : @[section4Row1], sectionHeaderHeight : @(15)};
	
	NSDictionary *section5Row1 = @{rowIdentifier : identifierSigninOrSignout,
								   accessory : @(NO),
								   selector : NSStringFromSelector(@selector(willSigninOrSignout))
								   };
	NSDictionary *section5 = @{sectionRows : @[section5Row1], sectionHeaderHeight : @(15)};
	
	_sectionsData = @[section1, section2, section3, section4, section5];
	
	NSString *networkingValue = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_NETWORKING];
	if (!networkingValue) {
		[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_NETWORKING_VALUE_AUTO forKey:ML_USER_DEFAULT_IDENTIFIER_NETWORKING];
	}
	
	NSString *pushValue = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_PUSH];
	if (!pushValue) {
		[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH];
	}
	
	NSString *pushSoundValue = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND];
	if (!pushSoundValue) {
		[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_SOUND_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND];
	}

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[_tableView reloadData];
}

- (void)willSigninOrSignout {
	if ([[MLAPIClient shared] sessionValid]) {
		[self willSignout];
	} else {
		[self willSignin];
	}
}

- (void)willSignout {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"退出登录", nil) message:NSLocalizedString(@"您确定要退出登录吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
	[alert show];
}

- (void)willSignin {
	MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
}

- (void)clearCache {
	[[MLAPIClient shared] removeUserAccount];
	[self displayHUDTitle:nil message:@"清空缓存..."];
}

- (void)about {
	MLAboutViewController *abountViewController = [[MLAboutViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:abountViewController animated:YES];
}

- (void)version {
	AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
	[appDelegate checkVersion];
}

- (void)share {
	[self socialShare:MLShareObjectAPP objectID:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		[self displayHUD:@"注销中..."];
		[[MLAPIClient shared] signoutWithBlock:^(NSString *message, NSError *error) {
			if (!error) {
				[self hideHUD:NO];
				if (message.length) {
					[self displayHUDTitle:nil message:message];
				}
				
				[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_SIGNOUT object:nil];
				
				[[MLAPIClient shared] makeSessionInvalid];
				[MLCache clearAllMoliGoodsData];
				[self.navigationController popViewControllerAnimated:YES];
			} else {
				[self displayHUDTitle:nil message:[error MLErrorDesc]];
			}
		}];
	}
}

#pragma mark - UITabelViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.separatorInset.left, 6, tableView.bounds.size.width - 2 * tableView.separatorInset.left, 30)];
	NSDictionary *sectionAttributes = _sectionsData[section];
	label.text = sectionAttributes[sectionTitle];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:15];
	[view addSubview:label];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSDictionary *sectionAttributes = _sectionsData[section];
	NSNumber *heightOfHeader = sectionAttributes[sectionHeaderHeight];
	return heightOfHeader ? heightOfHeader.floatValue : 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sectionsData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *sectionAttributes = _sectionsData[section];
	NSArray *rowsData = sectionAttributes[sectionRows];
	return rowsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *sectionAttributes = _sectionsData[indexPath.section];
	NSArray *rowsData = sectionAttributes[sectionRows];
	NSDictionary *rowAttributes = rowsData[indexPath.row];
	NSString *rIdentifier = rowAttributes[rowIdentifier];
	cell.textLabel.textColor = [UIColor fontGrayColor];
	cell.textLabel.text = rowAttributes[rowTitle];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.accessoryType = [rowAttributes[accessory] boolValue] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	NSString *key = rowAttributes[userDefaultKey];
	if (key) {
		NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		if ([value isEqualToString:rIdentifier]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
	
	if ([rIdentifier isEqualToString:identifierClearCache]) {
		cell.textLabel.font = [UIFont systemFontOfSize:18];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.backgroundColor = [UIColor whiteColor];
	} else if ([rIdentifier isEqualToString:identifierSigninOrSignout]) {
		cell.textLabel.font = [UIFont systemFontOfSize:18];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.backgroundColor = [UIColor themeColor];
		cell.textLabel.textColor = [UIColor whiteColor];
		if ([[MLAPIClient shared] sessionValid]) {
			cell.textLabel.text = @"安全退出";
		} else {
			cell.textLabel.text = @"登录";
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *sectionAttributes = _sectionsData[indexPath.section];
	NSArray *rowsData = sectionAttributes[sectionRows];
	NSDictionary *rowAttributes = rowsData[indexPath.row];
	NSString *rIdentifier = rowAttributes[rowIdentifier];
	NSString *selectorString = rowAttributes[selector];
	if (selectorString) {
		SEL selector = NSSelectorFromString(selectorString);
		[self performSelector:selector withObject:nil];
		return;
	} else {
		NSString *key = rowAttributes[userDefaultKey];
		if (key) {
			NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
			if ([key isEqualToString:ML_USER_DEFAULT_IDENTIFIER_NETWORKING]) {
				[[NSUserDefaults standardUserDefaults] setValue:rIdentifier forKey:ML_USER_DEFAULT_IDENTIFIER_NETWORKING];
			} else if ([key isEqualToString:ML_USER_DEFAULT_IDENTIFIER_PUSH]) {
				if (!value || [value isEqualToString:ML_USER_DEFAULT_PUSH_NONE_VALUE]) {
					[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH];
				} else {
					[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_NONE_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH];
					[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_NONE_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND];
					[[UIApplication sharedApplication] unregisterForRemoteNotifications];
				}
			} else if ([key isEqualToString:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND]) {
					AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
				if (!value || [value isEqualToString:ML_USER_DEFAULT_PUSH_NONE_VALUE]) {
					[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_SOUND_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND];
					[[NSUserDefaults standardUserDefaults] setValue:ML_USER_DEFAULT_PUSH_VALUE forKey:ML_USER_DEFAULT_IDENTIFIER_PUSH];
					[appDelegate registerRemoteNotificationWithSound:YES];
				} else {
					[[NSUserDefaults standardUserDefaults] removeObjectForKey:ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND];
					[appDelegate registerRemoteNotificationWithSound:NO];
				}
			}
			[[NSUserDefaults standardUserDefaults] synchronize];
			[tableView reloadData];
		}
	}
}

@end
