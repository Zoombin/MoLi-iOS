//
//  MLOrderStore.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderStore.h"

@implementation MLOrderStore

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _storeId = [attributes[@"storeid"] notNull];
        _storeName = [attributes[@"storename"] notNull];
        _telephone = [attributes[@"telephone"] notNull];
    }
    return self;
}

@end
