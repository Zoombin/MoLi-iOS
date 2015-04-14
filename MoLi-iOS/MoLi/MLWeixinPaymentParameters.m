//
//  MLWeixinPaymentParameters.m
//  MoLi
//
//  Created by zhangbin on 4/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLWeixinPaymentParameters.h"

@implementation MLWeixinPaymentParameters

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_appID = [attributes[@"appid"] notNull];
		_nonceString = [attributes[@"noncestr"] notNull];
		_package = [attributes[@"package"] notNull];
		_partnerID = [attributes[@"partnerid"] notNull];
		_prepayID = [attributes[@"prepayid"] notNull];
		_sign = [attributes[@"sign"] notNull];
		_timestampString = [attributes[@"timestamp"] notNull];
		_appKey = [attributes[@"appkey"] notNull];
	}
	return self;
}
@end
