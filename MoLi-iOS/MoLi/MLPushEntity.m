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
        _activity = [attributes[@"activity"] notNull];
        _param = [attributes[@"param"] notNull];
        _pagecode = [attributes[@"pagecode"] notNull];
        _url = [attributes[@"url"] notNull];
    }
    return self;
}
@end
