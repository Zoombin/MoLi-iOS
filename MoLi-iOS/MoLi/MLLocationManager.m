//
//  MLLocationManager.m
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLLocationManager.h"

@implementation MLLocationManager

+ (instancetype)shared;
{
	static MLLocationManager *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [[MLLocationManager alloc] init];
	});
	return _shared;
}

@end
