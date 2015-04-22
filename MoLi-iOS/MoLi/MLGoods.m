//
//  MLGoods.m
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoods.h"

@implementation MLGoods

- (instancetype)init {
	self = [super init];
	if (self) {
		_quantityInCart = @(1);
	}
	return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"goodsid"] notNull];
		_name = [attributes[@"goodsname"] notNull];
		NSString *imgpath = [attributes[@"goodsimage"] notNull];
        _imagePath = [imgpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		_price = [attributes[@"price"] notNull];
		_salesVolume = [attributes[@"salesvolume"] notNull];
		_highOpinion = [attributes[@"highopinion"] notNull];
		_gallery = [attributes[@"goodsimages"] notNull];
		_choose = [attributes[@"choose"] notNull];
		_goodsPropertiesString = [attributes[@"spec"] notNull];
		if ([attributes[@"introduce"] notNull]) {
			_multiIntroduce = [MLGoodsIntroduce multiWithAttributesArray:attributes[@"introduce"]];
		}
		if ([attributes[@"goodsprice"] notNull]) {
			_marketPrice = attributes[@"goodsprice"][@"market"];
			_VIPPrice = attributes[@"goodsprice"][@"viprmb"];
		}
		_favorited = [attributes[@"isfavorite"] notNull];
		_commentsNumber = [attributes[@"totalcomment"] notNull];
		_onSale = [attributes[@"onsale"] notNull];
		NSString *logoImage = [attributes[@"logo"] notNull];
        _logo = [logoImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		_goodsFrom = [attributes[@"goodsfrom"] notNull];
		_goodsTo = [attributes[@"goodsto"] notNull];
		_postage = [attributes[@"postage"] notNull];
		_postageWay = [attributes[@"postageway"] notNull];

		
		//购物车
		_displayGoodsPropertiesInCart = [attributes[@"specshow"] notNull];
		_quantityInCart = [attributes[@"num"] notNull];
		_hasStorage = [attributes[@"isstock"] notNull];
		_stock = [attributes[@"stock"] notNull];
		
        //评价订单
        _unique = [attributes[@"unique"] notNull];
        
		//订单
		_quantityBought = [attributes[@"num"] notNull];
		if ([attributes[@"image"] notNull]) {
            
			NSString *imgpathim = [attributes[@"image"] notNull];
            _imagePath = [imgpathim stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
		if ([attributes[@"name"] notNull]) {
			_name = [attributes[@"name"] notNull];
		}
		
        _service = [attributes[@"service"] notNull];
        _tradeid = [attributes[@"tradeid"] notNull];
		//猜你喜欢
		_voucher = [attributes[@"isvoucher"] notNull];
	}
	return self;
}

+ (NSArray *)handleMultiGoodsWillDeleteOrUpdate:(NSArray *)multiGoods {
	NSMutableArray *array = [NSMutableArray array];
	for (MLGoods *goods in multiGoods) {
		NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		parameters[@"goodsid"] = goods.ID;
		if (goods.goodsPropertiesString) {
			parameters[@"spec"] = goods.goodsPropertiesString;
		} else {
			parameters[@"spec"] = [goods selectedAllProperties];
		}
		if (goods.quantityInCart) {
			parameters[@"num"] = goods.quantityInCart;
		}
		[array addObject:parameters];
	}
	return array;
}

+ (NSArray *)createGoodsWithArray:(NSArray *)multiGoods {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *info in multiGoods) {
        MLGoods *goods = [[MLGoods alloc] initWithAttributes:info];
        [array addObject:goods];
    }
    return array;
}

- (NSString *)defaultProperties {
	NSMutableArray *properties = [NSMutableArray array];
	if (_goodsProperties.count) {
		for (MLGoodsProperty *property in _goodsProperties) {
			if (property.values.count) {
				[properties addObject:@"0"];
			}
		}
	}
	return properties.count ? [properties componentsJoinedByString:@"-"] : @"";
}

- (NSString *)selectedAllProperties {
	if (![self didSelectAllProperties]) {
		return [self defaultProperties];
	}
	NSMutableArray *properties = [NSMutableArray array];
	if (_goodsProperties.count) {
		for (MLGoodsProperty *property in _goodsProperties) {
			[properties addObject:property.selectedIndex];
		}
	}
	return properties.count ? [properties componentsJoinedByString:@"-"] : @"";
}


- (BOOL)voucherValid {
	return _voucher.integerValue == 1;
}

- (NSInteger)linesForMultiIntroduce {
	NSInteger count = 0;
	for (MLGoodsIntroduce *introduce in _multiIntroduce) {
		for (int i = 0; i < introduce.elements.count; i++) {
			count++;
		}
	}
	count += _multiIntroduce.count;
	return count;
}

- (NSString *)formattedIntroduce {
	NSMutableArray *array = [NSMutableArray array];
	for (MLGoodsIntroduce *introduce in _multiIntroduce) {
		[array addObject:[NSString stringWithFormat:@"%@:", introduce.title]];
		for (MLGoodsIntroduceElement *element in introduce.elements) {
			[array addObject:[NSString stringWithFormat:@"%@:%@", element.name, element.value]];
		}
	}
	return [array componentsJoinedByString:@"\n"];
}

- (BOOL)didSelectAllProperties {
	NSInteger count = 0;
	for (MLGoodsProperty *property in _goodsProperties) {
		if (property.selectedIndex) {
			count++;
		}
	}
	return count == _goodsProperties.count;
}

- (BOOL)sameGoodsWithSameSelectedProperties:(MLGoods *)goods {
	if ([goods.ID isEqualToString:_ID]) {
		if ([_goodsPropertiesString isEqualToString:_goodsPropertiesString]) {
			return YES;
		}
	}
	return NO;
}

- (NSString *)sumStringInCart {
	CGFloat sum = _quantityInCart.integerValue * _VIPPrice.floatValue;
	return [NSString stringWithFormat:@"%.2f", sum];
}

@end
