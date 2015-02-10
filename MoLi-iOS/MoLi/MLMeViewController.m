//
//  MLMeViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMeViewController.h"
#import "Header.h"
#import "MLSigninViewController.h"
#import "MLMemberViewController.h"
#import "MLVoucherViewController.h"
#import "MLUser.h"
#import "MLSigninViewController.h"
#import "MLProfileViewController.h"
#import "MLSecurityViewController.h"
#import "MLMessagesViewController.h"
#import "MLMyFavoritesViewController.h"
#import "MLOrdersViewController.h"
#import "MLViewHistoryViewController.h"
#import "MLServicesViewController.h"
#import "MLOrder.h"
#import "MLOrdersViewController.h"
#import "MLSettingsViewController.h"
#import "UIView+Badge.h"
#import "MLOrderSummary.h"
#import "MLFavoriteSummary.h"
#import "MLSigninViewController.h"

static NSString * const cellIcon = @"cellIcon";
static NSString * const cellTitle = @"cellTitle";
static NSString * const cellDisclosure = @"cellDisclosure";
static NSString * const cellTargetClass = @"cellTargetClass";
static CGFloat const heightOfCell = 48;

@interface MLMeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *data;
@property (readwrite) UIButton *signinButton;
@property (readwrite) UIImage *avatarPlaceholder;
@property (readwrite) UIImageView *avatarView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UIButton *profileButton;
@property (readwrite) UIButton *forPayButton;
@property (readwrite) UIButton *forSendButton;
@property (readwrite) UIButton *forTakeButton;
@property (readwrite) UIButton *forCommentButton;
@property (readwrite) MLOrderSummary *orderSummaryForPay;
@property (readwrite) MLOrderSummary *orderSummaryForSend;
@property (readwrite) MLOrderSummary *orderSummaryForTake;
@property (readwrite) MLOrderSummary *orderSummaryForComment;
@property (readwrite) MLFavoriteSummary *favoriteSummary;
@property (readwrite) NSNumber *numberOfNewMessages;

@end

@implementation MLMeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"魔力";
		
		UIImage *normalImage = [[UIImage imageNamed:@"Me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIImage *selectedImage = [[UIImage imageNamed:@"MeHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:normalImage selectedImage:selectedImage];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.navigationItem.title = @"我的魔力";

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 150);
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:rect];
	headerView.userInteractionEnabled = YES;
	headerView.image = [UIImage imageNamed:@"ProfileBackground"];
	_tableView.tableHeaderView = headerView;
	
	rect.size.width = 90;
	rect.size.height = 30;
	rect.origin.x = (self.view.frame.size.width - rect.size.width) / 2;
	rect.origin.y = 32;
	UIColor *colorOfSigninButton = [UIColor colorWithRed:88/255.0f green:82/255.0f blue:67/255.0f alpha:1.0f];
	_signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_signinButton.frame = rect;
	_signinButton.layer.borderColor = [colorOfSigninButton CGColor];
	_signinButton.layer.borderWidth = 1;
	[_signinButton setTitleColor:colorOfSigninButton forState:UIControlStateNormal];
	_signinButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[_signinButton setTitle:NSLocalizedString(@"登录/注册", nil) forState:UIControlStateNormal];
	_signinButton.backgroundColor = [UIColor clearColor];
	_signinButton.layer.cornerRadius = 4;
	[_signinButton addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:_signinButton];
	
	_avatarPlaceholder = [UIImage imageNamed:@"Avatar"];
	rect.origin.x = 20;
	rect.origin.y = 20;
	rect.size.width = _avatarPlaceholder.size.width;
	rect.size.height = _avatarPlaceholder.size.height;
	_avatarView = [[UIImageView alloc] initWithFrame:rect];
	_avatarView.image = _avatarPlaceholder;
	_avatarView.userInteractionEnabled = YES;
	_avatarView.layer.cornerRadius = 27;
	_avatarView.clipsToBounds = YES;
	_avatarView.layer.borderWidth = 2;
	_avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
	[headerView addSubview:_avatarView];
	
	rect.origin.x = CGRectGetMaxX(_avatarView.frame) + 10;
	rect.origin.y = CGRectGetMinY(_avatarView.frame) + 15;
	rect.size.width = self.view.frame.size.width - rect.origin.x;
	rect.size.height = 30;
	_nameLabel = [[UILabel alloc] initWithFrame:rect];
	_nameLabel.textColor = [UIColor blackColor];
	[headerView addSubview:_nameLabel];
	
	rect.size.width = 50;
	rect.size.height = 18;
	rect.origin.x = self.view.bounds.size.width - rect.size.width - 20;
	rect.origin.y = CGRectGetMinY(_nameLabel.frame) + 5;
	_profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_profileButton.frame = rect;
	[_profileButton setTitle:NSLocalizedString(@"修改信息", nil) forState:UIControlStateNormal];
	_profileButton.titleLabel.textColor = [UIColor whiteColor];
	_profileButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
	_profileButton.titleLabel.font = [UIFont systemFontOfSize:10];
	_profileButton.layer.cornerRadius = 4;
	[_profileButton addTarget:self action:@selector(profile) forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:_profileButton];
	
	rect.size.width = headerView.frame.size.width;
	rect.size.height = 56;
	rect.origin.x = 0;
	rect.origin.y = headerView.frame.size.height - rect.size.height;
	UIView *view = [[UIView alloc] initWithFrame:rect];
	view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.28];
	[headerView addSubview:view];
	
	UIFont *font = [UIFont systemFontOfSize:12];
	CGFloat edgeInsetsTopForImage = -20;
	CGFloat edgeInsetsTopForTitle = 25;
	
	rect.size.width = headerView.frame.size.width / 4;
	UIImage *forPayImage = [UIImage imageNamed:@"ForPay"];
	_forPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_forPayButton.frame = rect;
	[_forPayButton setImage:forPayImage forState:UIControlStateNormal];
	_forPayButton.showsTouchWhenHighlighted = YES;
	[_forPayButton setTitle:NSLocalizedString(@"待付款", nil) forState:UIControlStateNormal];
	_forPayButton.titleLabel.font = font;
	[_forPayButton.titleLabel sizeToFit];
	[_forPayButton setTitleEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForTitle, -forPayImage.size.width, 0, 0)];
	[_forPayButton setImageEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForImage, 0, 0, -_forPayButton.titleLabel.bounds.size.width)];
	[_forPayButton addTarget:self action:@selector(orders:) forControlEvents:UIControlEventTouchUpInside];
	_forPayButton.tag = MLOrderStatusForPay;
	[headerView addSubview:_forPayButton];
	
	rect.origin.x = CGRectGetMaxX(_forPayButton.frame);
	UIImage *forSendImage = [UIImage imageNamed:@"ForSend"];
	_forSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_forSendButton.frame = rect;
	[_forSendButton setImage:forSendImage forState:UIControlStateNormal];
	_forSendButton.showsTouchWhenHighlighted = YES;
	[_forSendButton setTitle:NSLocalizedString(@"待发货", nil) forState:UIControlStateNormal];
	_forSendButton.titleLabel.font = font;
	[_forSendButton.titleLabel sizeToFit];
	[_forSendButton setTitleEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForTitle, -forSendImage.size.width, 0, 0)];
	[_forSendButton setImageEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForImage, 0, 0, -_forSendButton.titleLabel.bounds.size.width)];
	[_forSendButton addTarget:self action:@selector(orders:) forControlEvents:UIControlEventTouchUpInside];
	_forSendButton.tag = MLOrderStatusForSend;
	[headerView addSubview:_forSendButton];
	
	rect.origin.x = CGRectGetMaxX(_forSendButton.frame);
	UIImage *forTakeImage = [UIImage imageNamed:@"ForTake"];
	_forTakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_forTakeButton.frame = rect;
	[_forTakeButton setImage:forTakeImage forState:UIControlStateNormal];
	_forTakeButton.showsTouchWhenHighlighted = YES;
	[_forTakeButton setTitle:NSLocalizedString(@"待收货", nil) forState:UIControlStateNormal];
	_forTakeButton.titleLabel.font = font;
	[_forTakeButton.titleLabel sizeToFit];
	[_forTakeButton setTitleEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForTitle, -forTakeImage.size.width, 0, 0)];
	[_forTakeButton setImageEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForImage, 0, 0, -_forTakeButton.titleLabel.bounds.size.width)];
	[_forTakeButton addTarget:self action:@selector(orders:) forControlEvents:UIControlEventTouchUpInside];
	_forTakeButton.tag = MLOrderStatusForTake;
	[headerView addSubview:_forTakeButton];
	
	rect.origin.x = CGRectGetMaxX(_forTakeButton.frame);
	UIImage *forCommentImage = [UIImage imageNamed:@"ForComment"];
	_forCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_forCommentButton.frame = rect;
	[_forCommentButton setImage:forCommentImage forState:UIControlStateNormal];
	_forCommentButton.showsTouchWhenHighlighted = YES;
	[_forCommentButton setTitle:NSLocalizedString(@"待评价", nil) forState:UIControlStateNormal];
	_forCommentButton.titleLabel.font = font;
	[_forCommentButton.titleLabel sizeToFit];
	[_forCommentButton setTitleEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForTitle, -forCommentImage.size.width, 0, 0)];
	[_forCommentButton setImageEdgeInsets:UIEdgeInsetsMake(edgeInsetsTopForImage, 0, 0, -_forCommentButton.titleLabel.bounds.size.width)];
	[_forCommentButton addTarget:self action:@selector(orders:) forControlEvents:UIControlEventTouchUpInside];
	_forCommentButton.tag = MLOrderStatusForComment;
	[headerView addSubview:_forCommentButton];
	
	rect.origin.x = CGRectGetMaxX(_forPayButton.frame);
	rect.origin.y = CGRectGetMinY(_forPayButton.frame) + 12;
	rect.size.width = 0.3;
	rect.size.height = 34;
	[headerView addSubview:[UIView verticalLineWithFrame:rect]];
	
	rect.origin.x = CGRectGetMaxX(_forSendButton.frame);
	[headerView addSubview:[UIView verticalLineWithFrame:rect]];
	
	rect.origin.x = CGRectGetMaxX(_forTakeButton.frame);
	[headerView addSubview:[UIView verticalLineWithFrame:rect]];
	
	NSArray *section = @[
						 @{cellIcon : @"AllOrders", cellTitle : @"全部订单", cellDisclosure : @"查看全部", cellTargetClass : [MLOrdersViewController class]}
						 ];
	
	NSArray *section2 = @[
						  @{cellIcon : @"Member", cellTitle : @"会员中心", cellDisclosure : @"会员特权、会员卡", cellTargetClass : [MLMemberViewController class]},
						  @{cellIcon : @"Credits", cellTitle : @"代金券", cellDisclosure : @"领取代金券、使用记录", cellTargetClass : [MLVoucherViewController class]}
						  ];
	
	NSArray *section3 = @[
						  @{cellIcon : @"Favorites", cellTitle : @"我的收藏", cellDisclosure : @"件收藏", cellTargetClass : [MLMyFavoritesViewController class]},
						  @{cellIcon : @"ViewHistory", cellTitle : @"我的足迹", cellTargetClass : [MLViewHistoryViewController class]},
						  @{cellIcon : @"Messages", cellTitle : @"我的消息", cellDisclosure : @"条未读消息", cellTargetClass : [MLMessagesViewController class]},
						  ];
	
	NSArray *section4 = @[
						  @{cellIcon : @"Services", cellTitle : @"服务", cellTargetClass : [MLServicesViewController class]}
						  ];
	
	NSArray *section5 = @[
						  @{cellIcon : @"Security", cellTitle : @"账户与安全", cellTargetClass : [MLSecurityViewController class]}
						  ];
	_data = @[section, section2, section3, section4, section5];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	BOOL valid = [[MLAPIClient shared] sessionValid];
	_signinButton.hidden = valid;
	_avatarView.hidden = !valid;
	_nameLabel.hidden = !valid;
	_profileButton.hidden = !valid;
	
	if (valid) {
		MLUser *me = [MLUser unarchive];
		[_avatarView setImageWithURL:[NSURL URLWithString:me.avatarURLString] placeholderImage:_avatarPlaceholder];
		_nameLabel.text = me.nickname;
		
		[[MLAPIClient shared] myOrdersSummaryWithBlock:^(NSDictionary *attributes, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				_orderSummaryForPay = [[MLOrderSummary alloc] initWithAttributes:attributes[@"forpay"]];
				_forPayButton.badge.badgeValue = _orderSummaryForPay.number.integerValue;
				_forPayButton.badge.outlineWidth = 0;
				_forPayButton.badge.badgeColor = [UIColor themeColor];
				_forPayButton.badge.minimumDiameter = 20;
				
				_orderSummaryForSend = [[MLOrderSummary alloc] initWithAttributes:attributes[@"forsend"]];
				_forSendButton.badge.badgeValue = _orderSummaryForSend.number.integerValue;
				_forSendButton.badge.outlineWidth = 0;
				_forSendButton.badge.badgeColor = [UIColor themeColor];
				
				_orderSummaryForTake = [[MLOrderSummary alloc] initWithAttributes:attributes[@"fortake"]];
				_forTakeButton.badge.badgeValue = _orderSummaryForTake.number.integerValue;
				_forTakeButton.badge.outlineWidth = 0;
				_forTakeButton.badge.badgeColor = [UIColor themeColor];
				
				_orderSummaryForComment = [[MLOrderSummary alloc] initWithAttributes:attributes[@"forcomment"]];
				_forCommentButton.badge.badgeValue = _orderSummaryForComment.number.integerValue;
				_forCommentButton.badge.outlineWidth = 0;
				_forCommentButton.badge.badgeColor = [UIColor themeColor];
			}
		}];
		
		[[MLAPIClient shared] myfavoritesSummaryWithBlock:^(NSDictionary *attributes, MLResponse *response) {
			if (response.success) {
				_favoriteSummary = [[MLFavoriteSummary alloc] initWithAttributes:attributes];
				[_tableView reloadData];
			}
		}];
		
		[[MLAPIClient shared] numberOfNewMessagesWithBlock:^(NSNumber *number, MLResponse *response) {
			if (response.success) {
				_numberOfNewMessages = number;
				[_tableView reloadData];
			}
		}];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)orders:(UIButton *)sender {
	MLOrdersViewController *ordersViewController = [[MLOrdersViewController alloc] initWithNibName:nil bundle:nil];
	ordersViewController.status = sender.tag;
	[self.navigationController pushViewController:ordersViewController animated:YES];
}

- (void)settings {
	MLSettingsViewController *settingsViewController = [[MLSettingsViewController alloc] initWithNibName:nil bundle:nil];
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)signin {
	MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
}

- (void)profile {
	MLProfileViewController *profileViewController = [[MLProfileViewController alloc] initWithNibName:nil bundle:nil];
	profileViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == _data.count - 1) {
		return 10;
	}
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return heightOfCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sectionData = _data[section];
	return sectionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSArray *sectionData = _data[indexPath.section];
	NSDictionary *cellAttributes = sectionData[indexPath.row];
	cell.imageView.image = [UIImage imageNamed:cellAttributes[cellIcon]];
	cell.textLabel.text = cellAttributes[cellTitle];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.textLabel.textColor = [UIColor fontGrayColor];
	NSString *text = cellAttributes[cellDisclosure];
	static NSInteger tag = 99;
	UIView *s = [cell.contentView viewWithTag:tag];
	[s removeFromSuperview];
	if (text.length) {
		CGRect rect = CGRectZero;
		rect.size.width = tableView.bounds.size.width - 35;
		rect.size.height = heightOfCell;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.textAlignment = NSTextAlignmentRight;
		label.textColor = [UIColor fontGrayColor];
		label.font = [UIFont systemFontOfSize:12];
		Class class = cellAttributes[cellTargetClass];
		label.text = text;
		if (class == [MLMyFavoritesViewController class]) {
			if ([[MLAPIClient shared] sessionValid]) {
				label.text = [NSString stringWithFormat:@"%@%@", [_favoriteSummary total] ?: @"", text];
			} else {
				label.text = nil;
			}
		} else if (class == [MLMessagesViewController class]) {
			if ([[MLAPIClient shared] sessionValid]) {
				label.text = [NSString stringWithFormat:@"%@%@", _numberOfNewMessages ?: @"", text];
			} else {
				label.text = nil;
			}
		}
		label.tag = tag;
		[cell.contentView addSubview:label];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSArray *sectionData = _data[indexPath.section];
	NSDictionary *cellAttributes = sectionData[indexPath.row];
	Class class = cellAttributes[cellTargetClass];
	if (class) {
		if (![[MLAPIClient shared] sessionValid] && class == [MLMemberViewController class]) {
			MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
			[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
			return;
		}
		UIViewController *controller = [[class alloc] initWithNibName:nil bundle:nil];
		controller.hidesBottomBarWhenPushed = YES;
        [controller setLeftBarButtonItemAsBackArrowButton];
		[self.navigationController pushViewController:controller animated:YES];
	}
}

@end
