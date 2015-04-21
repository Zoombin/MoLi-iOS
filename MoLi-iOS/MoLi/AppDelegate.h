//
//  AppDelegate.h
//  MoLi
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMeViewController.h"

/// delegate类
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) CGRect tabBarOriginRect;
@property (nonatomic,strong) MLMeViewController *meViewController;

- (void)registerRemoteNotificationWithSound:(BOOL)sound;
- (void)checkVersion;

@end

