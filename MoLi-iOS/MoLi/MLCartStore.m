//
//  MLCartStore.m
//  MoLi
//
//  Created by zhangbin on 12/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLCartStore.h"
#import "MLGoods.h"

@implementation MLCartStore

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"storeid"] notNull];
		_name = [attributes[@"storename"] notNull];
		NSArray *multiAttributes = [attributes[@"goods"] notNull];
		if (multiAttributes.count) {
			_multiGoods = [MLGoods multiWithAttributesArray:multiAttributes];
		}
		_shippingName = [attributes[@"postageway"] notNull];
		_shippingFee = [attributes[@"postage"] notNull];
		_numberOfGoods = [attributes[@"num"] notNull];
		_totalPrice = [attributes[@"totalprice"] notNull];
	}
	return self;
}

+ (NSArray *)handleCartStoresForSaveOrder:(NSArray *)cartStores {
	NSMutableArray *array = [NSMutableArray array];
	for	(MLCartStore *cartStore in cartStores) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		dictionary[@"storeid"] = cartStore.ID;
#warning TODO;
		dictionary[@"remark"] = @"";
		dictionary[@"goodslist"] = [MLGoods handleMultiGoodsWillDeleteOrUpdate:cartStore.multiGoods];
		[array addObject:dictionary];
	}
	return array;
}

@end
