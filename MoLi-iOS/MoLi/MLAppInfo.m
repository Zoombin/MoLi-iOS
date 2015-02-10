//
//  MLAppInfo.m
//  MoLi
//
//  Created by 颜超 on 15/1/31.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAppInfo.h"

@implementation MLAppInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _telephone = [attributes[@"telephone"] notNull];
        _copyright = [attributes[@"copyright"] notNull];
        _protocol = [attributes[@"protocol"] notNull];
        _usehelp = [attributes[@"usehelp"] notNull];
        _vipuserterms = [attributes[@"vipuserterms"] notNull];
        _vipuserprotocol = [attributes[@"vipuserprotocol"] notNull];
        _versiondesc = [attributes[@"versiondesc"] notNull];
    }
    return self;
}
@end
