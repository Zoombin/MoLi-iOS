//
//  MLGoodsImagesDetails.m
//  MoLi
//
//  Created by zhangbin on 12/22/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsImagesDetails.h"

@implementation MLGoodsImagesDetails

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_goodsID = [attributes[@"goodsid"] notNull];
		_name = [attributes[@"goodsname"] notNull];
		_imagePaths = [NSArray arrayWithArray:[attributes[@"goodscontent"] notNull]];
		_link = [attributes[@"linkaddress"] notNull];
	}
	return self;
}

@end
