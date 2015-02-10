//
//  MLStore.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStore.h"
#import "Header.h"

@implementation MLStore

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"businessid"] notNull];
		_imagePath = [attributes[@"businessimage"] notNull];
		_iconPath = [attributes[@"businessicon"] notNull];
		_name = [attributes[@"businessname"] notNull];
		_businessCategory = [attributes[@"industry"] notNull];
		_address = [attributes[@"address"] notNull];
		_describe = [attributes[@"description"] notNull];
		_starRated = [attributes[@"starlevel"] notNull];
		_commentsNumber = [attributes[@"totalcomment"] notNull];
		_phones = [NSArray arrayWithArray:[attributes[@"tel"] notNull]];
		NSString *lat = [attributes[@"lat"] notNull];
		NSString *lng = [attributes[@"lng"] notNull];
		if (lat && lng) {
			_location = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
		}
	}
	return self;
}

+ (UIImage *)imageByStoreCategory:(NSString *)category {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	dictionary[@"购物"] = @"StoreShoppingSmall";
	dictionary[@"餐饮"] = @"StoreFoodSmall";
	dictionary[@"教育"] = @"StoreStudySmall";
	dictionary[@"母婴"] = @"StoreBabySmall";
	dictionary[@"美容"] = @"StoreFaceSmall";
	dictionary[@"KTV"] = @"StoreKTVSmall";
	dictionary[@"住宿"] = @"StoreHouseSmall";
	NSString *imageName = dictionary[dictionary.allKeys.firstObject];
	for	(NSString *key in dictionary.allKeys) {
		if ([category.uppercaseString stringContainsString:key]) {
			imageName = dictionary[key];
			break;
		}
	}
	return [UIImage imageNamed:imageName];
}

@end
