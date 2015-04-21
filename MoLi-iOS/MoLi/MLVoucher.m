//
//  MLVoucher.m
//  MoLi
//
//  Created by zhangbin on 1/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucher.h"

@implementation MLVoucher

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		NSString *imagepath = [attributes[@"voucherimage"] notNull];
        _imagePath = [imagepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		_voucherCanCost = [attributes[@"totalvoucher"] notNull];
		_voucherWillGet = [attributes[@"voucher"] notNull];
		
		_orderNO = [attributes[@"orderno"] notNull];
		_storeName = [attributes[@"storename"] notNull];
		_goodsName = [attributes[@"goodsname"] notNull];
		_value = [attributes[@"voucher"] notNull];
	}
	return self;
}

@end
