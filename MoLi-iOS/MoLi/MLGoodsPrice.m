//
//  MLGoodsPrice.m
//  MoLi
//
//  Created by zhangbin on 4/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsPrice.h"

@implementation MLGoodsPrice

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_price = [attributes[@"goodsprice"] notNull];
		_isVoucher = [attributes[@"isvoucher"] notNull];
		_voucher = [attributes[@"voucher"] notNull];
		_stock = [attributes[@"stock"] notNull];
	}
	return self;
}

@end
