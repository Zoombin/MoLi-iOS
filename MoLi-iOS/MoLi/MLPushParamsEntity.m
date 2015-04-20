//
//  MLPushParamsEntity.m
//  MoLi
//
//  Created by yc on 15-4-20.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLPushParamsEntity.h"

@implementation MLPushParamsEntity

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _goodsid = [attributes[@"goodsid"] notNull];
        _fstoreid = [attributes[@"fstoreid"] notNull];
        _estoreid = [attributes[@"estoreid"] notNull];
        _bclassifyid = [attributes[@"bclassifyid"] notNull];
    }
    return self;
}

@end
