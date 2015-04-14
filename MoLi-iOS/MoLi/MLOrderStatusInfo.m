//
//  MLOrderStatusInfo.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderStatusInfo.h"

@implementation MLOrderStatusInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _current = [attributes[@"current"] notNull];
        _log = [attributes[@"log"] notNull];
    }
    return self;
}
@end
