//
//  MLOrderAddress.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderAddress.h"

@implementation MLOrderAddress

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _address = [attributes[@"address"] notNull];
        _addressid = [attributes[@"addressid"] notNull];
        _name = [attributes[@"name"] notNull];
        _postcode = [attributes[@"postcode"] notNull];
        _telephone = [attributes[@"telephone"] notNull];
    }
    return self;
}
@end
