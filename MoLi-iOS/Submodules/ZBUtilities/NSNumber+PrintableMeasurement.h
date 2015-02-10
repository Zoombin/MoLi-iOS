//
//  NSNumber+ReadableDistance.h
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (PrintableMeasurement)

- (NSString *)printableDistance;
- (NSString *)printableBytes;
- (NSString *)printableTimestamp;
- (NSString *)printableAge;
- (NSString *)printableHeight;
- (NSString *)printableWeight;
- (NSString *)printableChest;
- (NSString *)printableRMB;

@end
