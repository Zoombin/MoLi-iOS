//
//  CLLocation+NSDictionary.m
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "CLLocation+NSDictionary.h"

@implementation CLLocation (NSDictionary)

- (NSDictionary *)parseToDictionary
{
	return @{@"lat" : @(self.coordinate.latitude), @"lng" : @(self.coordinate.longitude)};
}

@end
