//
//  AppDelegate.m
//  MoLi
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
#import "MLMainViewController.h"
#import "MLCategoriesViewController.h"
#import "MLStoresViewController.h"
#import "MLCartViewController.h"
#import "MLMeViewController.h"
#import "MLVersion.h"
#import "MLSecurity.h"
#import "MLTicket.h"
#import "MLUser.h"
#import "MLGuideViewController.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MLSearchViewController.h"
//#import "BMapKit.h"
//TODO
#import "MLGoodsDetailsViewController.h"
#import "MLPrepareOrderViewController.h"
#import "MLIdentifyPasswordViewController.h"
#import "MLChangePasswordViewController.h"
#import "MLSettingsViewController.h"
#import "MLNewVoucherViewController.h"
#import "MLVoucherFlowViewController.h"
#import "MLStoreClassifiesViewController.h"
#import "MLStoreDetailsViewController.h"
#import "MLPaymentViewController.h"
#import "MLAfterSalesServiceViewController.h"
#import "MLAfterSalesLogisticViewController.h"
#import "MLPayResultViewController.h"

@interface AppDelegate () <
//BMKGeneralDelegate,
UITabBarControllerDelegate,
UIAlertViewDelegate,
MLGuideViewControllerDelegate
>

@property (readwrite) MLVersion *version;
@property (readwrite) UITabBarController *tabBarController;
@property (readwrite) MLMeViewController *meViewController;
@property (readwrite) UINavigationController *meNavigationController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
//     要使用百度地图，请先启动BaiduMapManager
//    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
//    BOOL ret = [mapManager start:@"4HuSISt8gtZvMxbzsZ25YCVE" generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOrders) name:ML_NOTIFICATION_IDENTIFIER_OPEN_ORDERS object:nil];
	
	[UMSocialData setAppKey:ML_UMENG_APP_KEY];
    [UMSocialWechatHandler setWXAppId:@"wx501bd7cea77cc83a" appSecret:@"89f629c822b71cabfe761f96265b4f71" url:@"http://www.imooly.com"];
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.imooly.com"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    
	[UMessage startWithAppkey:ML_UMENG_APP_KEY launchOptions:launchOptions];
	[self registerRemoteNotificationWithSound:YES];
	
	//TODO: to test
	[MLLocationManager shared].currentLocation = [[CLLocation alloc] initWithLatitude:31.267532 longitude:120.729301];
	[self customizeAppearance];
	
	NSNumber *displayed = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_DISPLAYED_GUIDE];
	if (!displayed) {
		[self addGuide];
	} else {
		[self addTabBar];
	}
	
	return YES;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#warning TODO
//    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#warning TODO
//    [BMKMapView didForeGround];
    
	[self fetchSecurityWithBlock:^{
		[self fetchTicketWithBlock:^{
			if ([[MLAPIClient shared] sessionValid]) {
				[[MLAPIClient shared] autoSigninWithBlock:^(NSDictionary *attributes, NSError *error) {
					if (!error) {
						MLUser *me = [[MLUser alloc] initWithAttributes:attributes];
						[me archive];
						
						MLTicket *ticket = [MLTicket unarchive];
						ticket.sessionID = me.sessionID;
						[ticket archive];
						
						[self checkVersion];
					} else {
						NSLog(@"auto signin error: %@", error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]);
					}
				}];
			} else {
				[self checkVersion];
			}
		}];
	}];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	[self handleOpenURL:url];
	return  YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	[self handleOpenURL:url];
	return YES;
}

- (void)handleOpenURL:(NSURL *)url {
	if ([url.scheme isEqualToString:ALIPAY_SCHEME]) {
		[[ZBPaymentManager shared] afterPay:ZBPaymentTypeAlipay withURL:url];
	} else if ([url.scheme isEqualToString:WEIXIN_APP_ID]) {
		[[ZBPaymentManager shared] afterPay:ZBPaymentTypeWeixin withURL:url];
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[UMessage registerDeviceToken:deviceToken];
	NSLog(@"deviceToken: %@", deviceToken);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	NSLog(@"notificationSettings: %@", notificationSettings);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[UMessage didReceiveRemoteNotification:userInfo];
	NSLog(@"didReceiveRemoteNotification userInf: %@", userInfo);
}

- (void)goOrders {
	[_tabBarController setSelectedViewController:_meNavigationController];
	[_meViewController orders:nil];
}

- (void)addGuide {
	MLGuideViewController *guideViewController = [[MLGuideViewController alloc] initWithNibName:nil bundle:nil];
	guideViewController.delegate = self;
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = guideViewController;
	[self.window makeKeyAndVisible];
}

- (void)addTabBar {
	NSMutableArray *controllers = [NSMutableArray array];
	
//	MLIdentifyPasswordViewController *controller = [[MLIdentifyPasswordViewController alloc] initWithNibName:nil bundle:nil];
//	MLVerifyCode *verifyCode = [[MLVerifyCode alloc] init];
//	verifyCode.type = MLVerifyCodeTypeForgotWalletPassword;
//	verifyCode.mobile = @"18662606288";
//	verifyCode.code = @"1234";
//	controller.verifyCode = verifyCode;
//	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:controller]];	
	
//	MLGoodsDetailsViewController *controller = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
//	MLGoods *goods = [[MLGoods alloc] init];
//	goods.ID = @"51e35a8545a040fe9948ba968373199b";
//	controller.goods = goods;
//	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:controller]];

//	MLPayment *payment = [[MLPayment alloc] init];
//	MLPayResultViewController *controller = [[MLPayResultViewController alloc] initWithNibName:nil bundle:nil];
//	controller.success = YES;
//	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:controller]];
	
	MLMainViewController *mainViewController = [[MLMainViewController alloc] initWithNibName:nil bundle:nil];
	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:mainViewController]];
	
	MLCategoriesViewController *categoriesViewController = [[MLCategoriesViewController alloc] initWithNibName:nil bundle:nil];
	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:categoriesViewController]];
	
	MLSearchViewController *searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
	searchViewController.isRoot = YES;
	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:searchViewController]];
	
	//MLStoresViewController *storesViewController = [[MLStoresViewController alloc] initWithNibName:nil bundle:nil];
	//[controllers addObject:[[UINavigationController alloc] initWithRootViewController:storesViewController] ];
	
	MLCartViewController *cartViewController = [[MLCartViewController alloc] initWithNibName:nil bundle:nil];
	[controllers addObject:[[UINavigationController alloc] initWithRootViewController:cartViewController]];
	
	_meViewController = [[MLMeViewController alloc] initWithNibName:nil bundle:nil];
	_meNavigationController = [[UINavigationController alloc] initWithRootViewController:_meViewController];
	[controllers addObject:_meNavigationController];
	
	_tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	_tabBarController.viewControllers = controllers;
	_tabBarController.delegate = self;
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = _tabBarController;
	[self.window makeKeyAndVisible];
}

- (void)fetchSecurityWithBlock:(void (^)())block {
	if ([MLSecurity unarchive]) {
		if (block) block();
		return;
	}
	[[MLAPIClient shared] appRegister:nil withBlock:^(NSDictionary *attributes, NSError *error) {
		if (!error) {
			NSLog(@"security: %@", attributes);
			MLSecurity *security = [[MLSecurity alloc] initWithAttributes:attributes];
			[security archive];
			[UMessage addAlias:security.appID type:@"IMOOLY_APP" response:^(id responseObject, NSError *error) {
				if (error) {
					NSLog(@"umeng add alias error:%@", error);
				}
			}];
		}
		if (block) block();
	}];
}

- (void)fetchTicketWithBlock:(void (^)())block {
	if (![MLSecurity unarchive]) {
		return;
	}
    
	[[MLAPIClient shared] ticketWithBlock:^(NSDictionary *attributes, NSError *error) {
		if (!error) {
			NSLog(@"ticket: %@", attributes);
            NSDate *date = [NSDate date];
            NSUInteger timestamp = (NSInteger)[date timeIntervalSince1970];
            NSMutableDictionary *prime = [NSMutableDictionary dictionaryWithDictionary:attributes];
            [prime setObject:[@(timestamp) stringValue] forKey:@"timestamp"];
            
			[[[MLTicket alloc] initWithAttributes:prime] archive];
		}
		if (block) block();
	}];
}

- (void)checkVersion {
	if (![MLSecurity unarchive] || ![MLTicket unarchive]) {
		return;
	}
	[[MLAPIClient shared] checkVersionWithBlock:^(NSDictionary *attributes, NSError *error) {
		if (!error) {
			_version = [[MLVersion alloc] initWithAttributes:attributes];
			NSString *title = [NSString stringWithFormat:@"有新版本:V%@", _version.latestVersion];
			NSString *cancel = _version.forceUpdate.boolValue ? nil : @"取消";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:_version.describe delegate:self cancelButtonTitle:cancel otherButtonTitles:@"立即更新", nil];
			[alert show];
		}
	}];
}

- (void)registerRemoteNotificationWithSound:(BOOL)sound {
	if ([UIDevice currentDevice].systemVersion.floatValue <= 8.0) {
		UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert;
		if (sound) {
			type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
		}
		[UMessage registerForRemoteNotificationTypes:type];
	} else {
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
		if (sound) {
			settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
		}
		[UMessage registerRemoteNotificationAndUserNotificationSettings:settings];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
#warning TODO:
		NSLog(@"jump to address: %@", _version.updateURLString);//TODO: jump
	}
}

#pragma mark - MLGuideViewControllerDelegate

- (void)endGuide {
	[[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ML_USER_DEFAULT_IDENTIFIER_DISPLAYED_GUIDE];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self addTabBar];
}

@end
