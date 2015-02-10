//
//  MLGoodsClassify.m
//  MoLi
//
//  Created by zhangbin on 12/9/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsClassify.h"

@implementation MLGoodsClassify

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"classifyid"] notNull];
		_name = [attributes[@"classifyname"] notNull];
		_caption = [attributes[@"caption"] notNull];
		_iconPath = [attributes[@"classifyicon"] notNull];
		NSArray *sub = [attributes[@"subclassify"] notNull];
		if (sub) {
			_subClassifies = [MLGoodsClassify multiWithAttributesArray:sub];
		}
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<id:%@, name:%@, sub:%@>", _ID, _name, _subClassifies];
}

@end
