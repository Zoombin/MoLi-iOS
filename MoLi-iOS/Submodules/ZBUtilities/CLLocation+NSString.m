//
//  CLLocation+NSString.m
//  find
//
//  Created by zhangbin on 8/29/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "CLLocation+NSString.h"

/* Formatting strings for location data output */
#define CoordinateFormat @"%.6f, %.6f"
#define LatLongFormat @"%.4f° %@, %.4f° %@"
#define AltitudeFormat @"%.2f meters %@"
#define AccuracyFormat @"%.2f meters"
#define CourseFormat @"%.4f° Clockwise from North"
#define SpeedFormat @"%.2f meters per second"

/* Directions */
#define North @"N"
#define South @"S"
#define East @"E"
#define West @"W"
#define AboveSeaLevel @"above sea level"
#define BelowSeaLevel @"below sea level"

@implementation CLLocation (NSString)

- (NSString *)coordinateString {
	if (self.horizontalAccuracy < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    return [NSString stringWithFormat:NSLocalizedString(CoordinateFormat, @"CoordinateFormat"), self.coordinate.latitude,  self.coordinate.longitude];
}

- (NSString *)localizedCoordinateString {
    if (self.horizontalAccuracy < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    NSString *latString = (self.coordinate.latitude < 0) ? NSLocalizedString(South, @"South") : NSLocalizedString(North, @"North");
    NSString *lonString = (self.coordinate.longitude < 0) ? NSLocalizedString(West, @"West") : NSLocalizedString(East, @"East");
    return [NSString stringWithFormat:NSLocalizedString(LatLongFormat, @"LatLongFormat"), fabs(self.coordinate.latitude), latString, fabs(self.coordinate.longitude), lonString];
}

- (NSString *)localizedAltitudeString {
    if (self.verticalAccuracy < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    NSString *seaLevelString = (self.altitude < 0) ? NSLocalizedString(BelowSeaLevel, @"BelowSeaLevel") : NSLocalizedString(AboveSeaLevel, @"AboveSeaLevel");
    return [NSString stringWithFormat:NSLocalizedString(AltitudeFormat, @"AltitudeFormat"), fabs(self.altitude), seaLevelString];
}

- (NSString *)localizedHorizontalAccuracyString {
    if (self.horizontalAccuracy < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    return [NSString stringWithFormat:NSLocalizedString(AccuracyFormat, @"AccuracyFormat"), self.horizontalAccuracy];
}

- (NSString *)localizedVerticalAccuracyString {
    if (self.verticalAccuracy < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    return [NSString stringWithFormat:NSLocalizedString(AccuracyFormat, @"AccuracyFormat"), self.verticalAccuracy];
}

- (NSString *)localizedCourseString {
    if (self.course < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    return [NSString stringWithFormat:NSLocalizedString(CourseFormat, @"CourseFormat"), self.course];
}

- (NSString *)localizedSpeedString {
    if (self.speed < 0) {
        return NSLocalizedString(@"DataUnavailable", @"DataUnavailable");
    }
    return [NSString stringWithFormat:NSLocalizedString(SpeedFormat, @"SpeedFormat"), self.speed];
}

@end
