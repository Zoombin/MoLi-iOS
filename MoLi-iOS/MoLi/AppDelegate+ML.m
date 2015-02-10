//
//  AppDelegate+ML.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "AppDelegate+ML.h"
#import "UIColor+ML.h"
#import "UIImage+LogN.h"

@implementation AppDelegate (ML)

- (void)customizeAppearance
{
	//StatusBar
	if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	} else {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}
	
	//NavigationBar
	UIColor *color = [UIColor colorWithRed:250/255.0f green:250/255.0 blue:250/255.0f alpha:1.0f];
	id appearance = [UINavigationBar appearance];
	if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
		[appearance setBarTintColor:color];
		[appearance setTintColor:color];
	} else {
		//[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor customGrayColor]] forBarMetrics:UIBarMetricsDefault];
	}
	[appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
	
	//TabBar
	appearance = [UITabBar appearance];
	if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
		;
	} else {
		[appearance setSelectionIndicatorImage:[UIImage new]];
		[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]];
	}
	
	//TabBarItem
	appearance = [UITabBarItem appearance];
	[appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
	[appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor themeColor]} forState:UIControlStateSelected];
	
	//BarButtonItem
	appearance = [UIBarButtonItem appearance];
//	if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
//	[appearance setBackgroundColor:[UIColor whiteColor]];
//	[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]];	
	[appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
//	} else {
//		[appearance setBackButtonBackgroundImage:[[UIImage imageNamed:@"BackArrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//		[appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(5, -2) forBarMetrics:UIBarMetricsDefault];
//		[appearance setTitleTextAttributes:@{UITextAttributeFont : [UIFont fontFZLTXHOfSize:17], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateNormal];
//	}
}

@end
