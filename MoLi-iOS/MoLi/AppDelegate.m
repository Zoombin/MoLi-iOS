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
#import <AlipaySDK/AlipaySDK.h>
//#import "BMapKit.h"
//TODO
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
#import "MLPushEntity.h"
#import "MLPushParamsEntity.h"
#import "MLWebViewController.h"

#import "MLGoodsDetailsViewController.h"
#import "MLFlagshipStoreViewController.h"
#import "MLStoresViewController.h"
#import "MLMemberCardViewController.h"
#import "MLVoucherViewController.h"
#import "MLPrivilegeViewController.h"
#import "MLMyFavoritesViewController.h"
#import <CoreLocation/CoreLocation.h>

#define PUSH_TAG  1000
#define VERSION_TAG 1001

@interface AppDelegate () <
//BMKGeneralDelegate,
UITabBarControllerDelegate,
UIAlertViewDelegate,
MLGuideViewControllerDelegate, CLLocationManagerDelegate
>

@property (readwrite) MLVersion *version;
@property (readwrite) UITabBarController *tabBarController;
@property (readwrite) MLMainViewController *mainViewController;
@property (readwrite) MLCategoriesViewController *categoriesViewController;
@property (readwrite) MLSearchViewController *searchViewController;
@property (readwrite) MLCartViewController *cartViewController;
@property (readwrite) UINavigationController *meNavigationController;
@property (readwrite) UIView *redDotView;
@property (readwrite) NSDictionary *pushInfo;
@property (readwrite) CLLocationManager *locationManager;

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
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 50;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        [_locationManager requestWhenInUseAuthorization];//添加这句
    }
    [_locationManager startUpdatingLocation];
	
    NSNumber *displayed = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_DISPLAYED_GUIDE];
    if (!displayed) {
        [self addGuide];
    } else {
        [self addTabBar];
        NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification != nil) {
            [self showPushAlert:remoteNotification andShouldShow:NO];
        }
    }
    [self customizeAppearance];
    return YES;
}

- (void)showPushAlert:(NSDictionary *)userInfo andShouldShow:(BOOL)show{
    _pushInfo = userInfo;
    MLPushEntity *pushEntity = [[MLPushEntity alloc] initWithAttributes:userInfo];
    if (!show) {
        [self dealWithMessage:userInfo];
        return;
    }
    NSString *message = @"";
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSDictionary class]]) {
        message = userInfo[@"aps"][@"alert"][@"body"];
    } else {
        message = userInfo[@"aps"][@"alert"];
    }
    if ([pushEntity.activity isEqualToString:@"app"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"魔力网"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil];
        alertView.tag = PUSH_TAG;
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"魔力网"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"去看看", nil];
        alertView.tag = PUSH_TAG;
        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取所在地城市名
//    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocation *location = [locations lastObject];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error)
//     {
//         for(CLPlacemark *placemark in placemarks)
//         {
       if ([MLLocationManager shared].currentLocation) {
            return;
       }
        [MLLocationManager shared].currentLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//         }
//     }];
    [self.locationManager stopUpdatingLocation];

    [self fetchSecurityGetLocation:YES WithBlock:^{
        
    }];

    
}


/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    获取所在地城市名
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for(CLPlacemark *placemark in placemarks)
         {
             [MLLocationManager shared].currentLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
         }
     }];
    [self.locationManager stopUpdatingLocation];
}
 */

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self fetchSecurityGetLocation:YES WithBlock:^{
        
    }];
    if ([error code] == kCLErrorDenied) {
        //访问被拒绝
        NSLog(@"无法获取位置信息,请确认是否打开定位!");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息,请确认是否打开定位!");
    }
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
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];
	[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		if (status != AFNetworkReachabilityStatusNotReachable) {
            BOOL flag = NO;
            if ([MLLocationManager shared].currentLocation) {
                flag = YES;
            }
			[self fetchSecurityGetLocation:flag WithBlock:^{
					[self fetchTicketWithBlock:^{
					
					[[MLGlobal shared] fetchGlobalData];
					
					if ([[MLAPIClient shared] sessionValid]) {
						
						[[MLAPIClient shared] autoSigninWithBlock:^(NSDictionary *attributes, MLResponse *response, NSError *error) {
							if (response.success) {
								MLUser *me = [[MLUser alloc] initWithAttributes:attributes];
								[me archive];
								
//								MLTicket *ticket = [MLTicket unarchive];
//								[ticket setDate:[NSDate date]];
//								[ticket archive];
							} else {
								NSLog(@"auto signin error: %@", response.message);
							}
						}];
					}
				}];
			}];
		}
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
    [UMSocialSnsService handleOpenURL:url];
	if ([url.host isEqualToString:@"safepay"]) {//alipay
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (alertView.tag == PUSH_TAG) {
            [self dealWithMessage:_pushInfo];
        } else {
            NSLog(@"jump to address: %@", _version.updateURLString);//TODO: jump
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_version.updateURLString]];
        }
    }
}

- (void)dealWithMessage:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification userInf: %@", userInfo);
    MLPushEntity *pushEntity = [[MLPushEntity alloc] initWithAttributes:userInfo];
    NSString *activity = pushEntity.activity;
    if ([@"page" isEqualToString:activity]) {
        NSString *pageCode = pushEntity.pagecode;
        if ([pageCode length] == 0 || pageCode == nil) {
            //推送消息格式错误
            NSLog(@"%@", @"推送消息格式错误");
            return;
        }
        NSDictionary *params = pushEntity.param;
        NSLog(@"params == %@", params);
        if ([params allKeys] != 0) {
            MLPushParamsEntity *paramsEntity = [[MLPushParamsEntity alloc] initWithAttributes:params];
            [self showDetailWithPageCode:pushEntity.pagecode
                               andParams:paramsEntity];
        }
    } else if ([@"app" isEqualToString:activity]) {
        NSLog(@"不做操作");
    } else if ([@"link" isEqualToString:activity]) {
        if (_tabBarController) {
            NSString *url = pushEntity.url;
            MLWebViewController *webViewCtrl = [MLWebViewController new];
            [webViewCtrl setLeftBarButtonItemAsBackArrowButton];
            webViewCtrl.URLString = url;
            webViewCtrl.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)_tabBarController.selectedViewController pushViewController:webViewCtrl animated:YES];
        }
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self showPushAlert:userInfo andShouldShow:YES];
//  [UMessage didReceiveRemoteNotification:userInfo];
}

#define BN01  @"BN01" // 商品详情
#define SH01  @"SH01" // 店铺
#define PH01  @"PH01" // 实体店详情
#define CD01  @"CD01" // 电子会员卡
#define CD02  @"CD02" // 代金卷
#define MP01  @"MP01" // 会员特权
#define MC01  @"MC01" // 我的收藏

- (void)showDetailWithPageCode:(NSString *)pageCode
                     andParams:(MLPushParamsEntity *)params {
    Class class = [self classOfRedirect:pageCode];
    id viewController = [class new];
    if ([BN01 isEqualToString:pageCode]) {
        // 商品详情
        NSLog(@"商品详情");
        //test 8fd841d977d841f8809a00e97bef7365
        if ([params.goodsid length] == 0 || params.goodsid == nil) {
            return;
        }
        MLGoods *goods = [[MLGoods alloc] init];
        goods.ID = params.goodsid;
        [(MLGoodsDetailsViewController *)viewController setGoods:goods];
    } else if ([SH01 isEqualToString:pageCode]) {
        // 店铺
        NSLog(@"店铺");
        if ([params.fstoreid length] == 0 || params.fstoreid == nil) {
            return;
        }
        //test 93AF4AEF-458B-D124-A845-1F0E2EE7D24F
        MLFlagshipStore *shop = [[MLFlagshipStore alloc] init];
        shop.ID = params.fstoreid;
        [(MLFlagshipStoreViewController *)viewController setFlagshipStore:shop];
    } else if ([PH01 isEqualToString:pageCode]) {
        // 实体店详情
        NSLog(@"实体店详情");
        if ([params.estoreid length] == 0 || params.estoreid == nil) {
            return;
        }
        MLStore *store = [[MLStore alloc] init];
        store.ID = params.estoreid;
        [(MLStoreDetailsViewController *)viewController setStore:store];
    } else if ([CD01 isEqualToString:pageCode]) {
        // 电子会员卡
        NSLog(@"电子会员卡");
    } else if ([CD02 isEqualToString:pageCode]) {
        // 代金卷
        NSLog(@"代金券");
    } else if ([MP01 isEqualToString:pageCode]) {
        // 会员特权
        NSLog(@"会员特权");
    } else if ([MC01 isEqualToString:pageCode]) {
        // 我的收藏
        NSLog(@"我的收藏");
    }
    [viewController setHidesBottomBarWhenPushed:YES];
    [(UINavigationController *)_tabBarController.selectedViewController pushViewController:viewController animated:YES];
}

- (Class)classOfRedirect:(NSString *)pageCode {
    NSDictionary *dictionary = @{@"BN01" : [MLGoodsDetailsViewController class],
                                 @"SH01" : [MLFlagshipStoreViewController class],
                                 @"PH01" : [MLStoreDetailsViewController class],
                                 @"CD01" : [MLMemberCardViewController class],
                                 @"CD02" : [MLVoucherViewController class],
                                 @"MP01" : [MLPrivilegeViewController class],
                                 @"MC01" : [MLMyFavoritesViewController class],
                                 };
    Class class = nil;
    class = dictionary[pageCode.uppercaseString];
    return class;
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
    
    _mainViewController = [[MLMainViewController alloc] initWithNibName:nil bundle:nil];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:_mainViewController]];
    
    _categoriesViewController = [[MLCategoriesViewController alloc] initWithNibName:nil bundle:nil];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:_categoriesViewController]];
    
    _searchViewController = [[MLSearchViewController alloc] initWithNibName:nil bundle:nil];
    _searchViewController.isRoot = YES;
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:_searchViewController]];
    
    //MLStoresViewController *storesViewController = [[MLStoresViewController alloc] initWithNibName:nil bundle:nil];
    //[controllers addObject:[[UINavigationController alloc] initWithRootViewController:storesViewController] ];
    
    _cartViewController = [[MLCartViewController alloc] initWithNibName:nil bundle:nil];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:_cartViewController]];
    
    _meViewController = [[MLMeViewController alloc] initWithNibName:nil bundle:nil];
    _meNavigationController = [[UINavigationController alloc] initWithRootViewController:_meViewController];
    [controllers addObject:_meNavigationController];
    
    _tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    _tabBarController.viewControllers = controllers;
    _tabBarController.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRedDot) name:ML_NOTIFICATION_IDENTIFIER_RED_DOT object:nil];
    
    _tabBarOriginRect = _tabBarController.tabBar.frame;
}

- (void)fetchSecurityGetLocation:(BOOL)flag WithBlock:(void (^)())block {
    if (flag) {
        if ([MLSecurity unarchive]) {
            if (block) block();
            return;
        }
    }else{
    
        return;
    }

	
    [[MLAPIClient shared] appRegister:[[MLLocationManager shared] currentLocation] withBlock:^(NSDictionary *attributes, NSError *error) {
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
	
	if ([MLTicket valid]) {
		if (block) block();
		return;
	}
	
    [[MLAPIClient shared] ticketWithBlock:^(NSDictionary *attributes, NSError *error) {
        if (!error) {
            MLTicket *ticket = [[MLTicket alloc] initWithAttributes:attributes];
            [ticket setDate:[NSDate date]];
            [ticket archive];
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
            alert.tag = VERSION_TAG;
            [alert show];
        }
    }];
}

- (void)addRedDot {
    CGFloat startX = [UIScreen mainScreen].bounds.size.width / 5 * 4 - 20;
    _redDotView = [[UIView alloc] initWithFrame:CGRectMake(startX, 10, 8, 8)];
    _redDotView.backgroundColor = [UIColor redColor];
    _redDotView.layer.cornerRadius = 4;
    [_cartViewController.tabBarController.tabBar addSubview:_redDotView];
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

#pragma mark - UITabbarDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        [_mainViewController.navigationController popToRootViewControllerAnimated:NO];
    } else if (tabBarController.selectedIndex == 1) {
        [_categoriesViewController.navigationController popToRootViewControllerAnimated:YES];
    } else if (tabBarController.selectedIndex == 2) {
        [_searchViewController.navigationController popToRootViewControllerAnimated:YES];
    } else if (tabBarController.selectedIndex == 3) {
        [_cartViewController.navigationController popToRootViewControllerAnimated:YES];
        [_redDotView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ML_USER_DEFAULT_NEW_GOODS_COUNT_ADDED_TO_CART];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (tabBarController.selectedIndex == 4) {
        [_meViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    _tabBarController.tabBar.frame = _tabBarOriginRect;
}

#pragma mark - MLGuideViewControllerDelegate

- (void)endGuide {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ML_USER_DEFAULT_IDENTIFIER_DISPLAYED_GUIDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self addTabBar];
}

@end
