//
//  MLStoreClassify.m
//  MoLi
//
//  Created by zhangbin on 1/28/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLStoreClassify.h"

@implementation MLStoreClassify

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"classifyid"] notNull];
		_name = [attributes[@"classifyname"] notNull];
		_imagePath = [attributes[@"classifyicon"] notNull];
		_smallImagePath = [attributes[@"onsmallicon"] notNull];
		_smallHighlightedImagePath = [attributes[@"outsmallicon"] notNull];
		if ([attributes[@"subclassify"] notNull]) {
			_subClassifies = [MLStoreClassify multiWithAttributesArray:attributes[@"subclassify"]];
		}
	}
	return self;
}

@end
