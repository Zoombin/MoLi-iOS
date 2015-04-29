//
//  MLTicket.h
//  MoLi
//
//  Created by zhangbin on 11/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// ticket信息.
@interface MLTicket : ZBModel <NSCoding>

@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSNumber *timestamp;

+ (BOOL)valid;
- (void)setDate:(NSDate *)date;

@end
