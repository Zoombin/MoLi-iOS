//
//  MLAddress.m
//  MoLi
//
//  Created by zhangbin on 1/13/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAddress.h"

@implementation MLAddress

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"addressid"] notNull];
		_provinceID = [attributes[@"provinceid"] notNull];
		_cityID = [attributes[@"cityid"] notNull];
		_areaID = [attributes[@"areaid"] notNull];
		_province = [attributes[@"province"] notNull];
		_city = [attributes[@"city"] notNull];
		_area = [attributes[@"area"] notNull];
		_street = [attributes[@"street"] notNull];
		_postcode = [attributes[@"postcode"] notNull];
		_name = [attributes[@"name"] notNull];
		_phone = [attributes[@"tel"] notNull];
		_mobile = [attributes[@"mobile"] notNull];
		_isDefault = [attributes[@"isdefault"] notNull];
	}
	return self;
}

@end
