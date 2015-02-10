//
//  UIDevice+ZBUtilites.h
//  BookReader
//
//  Created by zhangbin on 8/17/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UDID_1 @"064f18ddbfb8bd1492ce34752a787a9342843823"//BAO
#define UDID_2 @"dde8a7554922df46211850bef00a9c0ad14cc245"//BAO2
#define UDID_3 @"3460767d19ed7b2f3cc5aa554f0c58761478c672"//BAO3
#define UDID_4 @"44ef9f5838d0fd52cb5a7a52db702c55f7a730b4"//DaiYe
#define UDID_5 @"fda6cea28b14cdf070e3992b12e37fb105f57c9d"//HuYangpin
#define UDID_6 @"4a02cb9966d82cca182f2b0f51e7c01e27c20f10"//YanChao
#define UDID_7 @"7794a4424141afd0c006de27e58a1611e32eb464"//ZhangBin iPhone4
#define UDID_8 @"e4bd51396a099e8d96de4e09850d4271b17bbd81"//ZhangBin iPhone5
#define UDID_9 @"8e3f2a2a76086ca4806bc94fd3c478decf48fde6"//ZhangBin iPad


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface UIDevice (ZBUtilites)

+ (BOOL)is4Inch;
+ (CGFloat)heightOf4Inch;
+ (CGFloat)heightOf3dot5Inch;

@end
