//
//  MLPushEntity.m
//  MoLi
//
//  Created by yc on 15-4-20.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLPushEntity.h"

@implementation MLPushEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        NSDictionary *result = attributes;
        if ([[result allKeys] containsObject:@"custom"]) {
            result = attributes[@"custom"];
        }
        _activity = [result[@"activity"] notNull];
        _param = [result[@"param"] notNull];
        _pagecode = [result[@"pagecode"] notNull];
        _url = [result[@"url"] notNull];
    }
    return self;
}
@end
