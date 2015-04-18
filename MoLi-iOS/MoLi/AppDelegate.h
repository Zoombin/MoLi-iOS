//
//  AppDelegate.h
//  MoLi
//
//  Created by zhangbin on 11/11/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// delegate类
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerRemoteNotificationWithSound:(BOOL)sound;
- (void)checkVersion;

@end

