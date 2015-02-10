//
//  MLAfterSalesGoods.m
//  MoLi
//
//  Created by zhangbin on 2/1/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAfterSalesGoods.h"

@implementation MLAfterSalesGoods

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_orderNO = [attributes[@"orderno"] notNull];
		_tradeID = [attributes[@"tradeid"] notNull];
		_goodsID = [attributes[@"goodsid"] notNull];
		_unique = [attributes[@"unique"] notNull];
		_imagePath = [attributes[@"image"] notNull];
		_name = [attributes[@"name"] notNull];
		_price = [attributes[@"price"] notNull];
		_number = [attributes[@"num"] notNull];
		_typeString = [attributes[@"type"] notNull];
		if (_typeString) {
			if ([_typeString isEqualToString:@"change"]) {
				_type = MLAfterSalesTypeChange;
			} else {
				_type = MLAfterSalesTypeReturn;
			}
			
		}		
		_status = attributes[@"statusname"];
		if ([attributes[@"oplist"] notNull]) {
			_orderOperators = [MLOrderOperator multiWithAttributesArray:attributes[@"oplist"]];
		}
	}
	return self;
}

@end
