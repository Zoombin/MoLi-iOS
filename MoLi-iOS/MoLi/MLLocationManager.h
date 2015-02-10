//
//  MLLocationManager.h
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MLLocationManager : NSObject

@property (nonatomic, strong) CLLocation *currentLocation;

+ (instancetype)shared;

@end
