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
		NSString *imgpath = [attributes[@"classifyicon"] notNull];
    
        _imagePath = [imgpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *smallpath = [attributes[@"onsmallicon"] notNull];
        
        _smallImagePath = [smallpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		NSString *smallhightpath = [attributes[@"outsmallicon"] notNull];
          _smallHighlightedImagePath = [smallhightpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		if ([attributes[@"subclassify"] notNull]) {
			_subClassifies = [MLStoreClassify multiWithAttributesArray:attributes[@"subclassify"]];
		}
	}
	return self;
}

@end
