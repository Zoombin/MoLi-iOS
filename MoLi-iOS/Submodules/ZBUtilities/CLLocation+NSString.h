//
//  CLLocation+NSString.h
//  find
//
//  Created by zhangbin on 8/29/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (NSString)

- (NSString *)coordinateString;
- (NSString *)localizedCoordinateString;
- (NSString *)localizedAltitudeString;
- (NSString *)localizedHorizontalAccuracyString;
- (NSString *)localizedVerticalAccuracyString;
- (NSString *)localizedCourseString;
- (NSString *)localizedSpeedString;

@end
