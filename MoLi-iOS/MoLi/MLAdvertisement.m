//
//  MLAdvertisement.m
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAdvertisement.h"

@implementation MLAdvertisement

+ (MLAdvertisement *)advertisementOfType:(MLAdvertisementType)type inAdvertisements:(NSArray *)advertisements {
	for (MLAdvertisement *ad in advertisements) {
		if ([ad advertisementType] == type) {
			return ad;
			break;
		}
	}
	return nil;
}

+ (NSArray *)severalAdvertisementsOfType:(MLAdvertisementType)type inAdvertisements:(NSArray *)advertisements {
	NSMutableArray *array = [NSMutableArray array];
	for (MLAdvertisement *ad in advertisements) {
		if ([ad advertisementType] == type) {
			[array addObject:ad];
		}
	}
	return array;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_ID = [attributes[@"adid"] notNull];
		_type = [attributes[@"type"] notNull];
		if ([attributes[@"infos"] notNull]) {
			_elements = [MLAdvertisementElement multiWithAttributesArray:[attributes[@"infos"] notNull]];
		}
	}
	return self;
}

- (MLAdvertisementType)advertisementType {
	if ([_type.uppercaseString isEqualToString:@"T001"]) {
		return MLAdvertisementTypeBanner;
	} else if ([_type.uppercaseString isEqualToString:@"T005"]) {
		return MLAdvertisementTypeShortcut;
	} else if ([_type.uppercaseString isEqualToString:@"T002"] || [_type.uppercaseString isEqualToString:@"T003"]) {
		return MLAdvertisementTypeNormal;
	}
	return MLAdvertisementTypeHot;//T004
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<id:%@, type:%@, elements:%@>", _ID, _type, _elements];
}

@end
