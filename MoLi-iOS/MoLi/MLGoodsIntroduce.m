//
//  MLGoodsIntroduce.m
//  MoLi
//
//  Created by zhangbin on 1/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsIntroduce.h"

@implementation MLGoodsIntroduce

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_title = [attributes[@"title"] notNull];
		if ([attributes[@"list"] notNull]) {
			_elements = [MLGoodsIntroduceElement multiWithAttributesArray:attributes[@"list"]];
		}
	}
	return self;
}


@end
