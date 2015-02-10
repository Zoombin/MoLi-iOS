//
//  MLStoreLocation.m
//  MoLi
//
//  Created by 颜超 on 15/2/1.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLStoreLocation.h"

@implementation MLStoreLocation

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _address = [attributes[@"address"] notNull];
        _businessicon = [attributes[@"businessicon"] notNull];
        _businessid = [attributes[@"businessid"] notNull];
        _businessname = [attributes[@"businessname"] notNull];
        _industry = [attributes[@"industry"] notNull];
        _industryid = [attributes[@"industryid"] notNull];
        _lat = [attributes[@"lat"] notNull];
        _lng = [attributes[@"lng"] notNull];
        _telephone = [attributes[@"telephone"] notNull];
    }
    return self;
}

@end
