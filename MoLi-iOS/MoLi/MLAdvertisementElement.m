//
//  MLAdvertisementElement.m
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAdvertisementElement.h"
#import "MLGoodsDetailsViewController.h"
#import "MLStoresViewController.h"
#import "MLStoreDetailsViewController.h"
#import "MLMemberCardViewController.h"
#import "MLVoucherViewController.h"
#import "MLPrivilegeViewController.h"
#import "MLFavoritesViewController.h"
#import "MLSearchResultViewController.h"
#import "MLStoresSearchResultViewController.h"
#import "MLStoreClassifiesViewController.h"
#import "MLMyFavoritesViewController.h"

@implementation MLAdvertisementElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_pageCode = [attributes[@"apppagecode"] notNull];
		_imagePath = [attributes[@"imagepath"] notNull];
		_parameterID = [attributes[@"paramid"] notNull];
		_redirectType = [attributes[@"redirect"] notNull];
		_title = [attributes[@"title"] notNull];
		_URLString = [attributes[@"url"] notNull];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<pageCode:%@, imagePaht:%@, parameterID:%@, redirectType:%@, title:%@, URLString:%@>", _pageCode, _imagePath, _parameterID, _redirectType, _title, _URLString];
}

- (BOOL)isOpenWebView {
	return [_redirectType.uppercaseString isEqualToString:@"I"];
}

- (Class)classOfRedirect {
	NSDictionary *dictionary = @{@"BN01" : [MLGoodsDetailsViewController class],
#warning SH01不确定是什么
								 @"SH01" : [MLStoresViewController class],
								 @"PH01" : [MLStoreDetailsViewController class],
								 @"CD01" : [MLMemberCardViewController class],
								 @"CD02" : [MLVoucherViewController class],
#warning MP0 是会员特权
                                 @"MP0"  : [MLPrivilegeViewController class],
								 @"MP01" : [MLPrivilegeViewController class],
								 @"MC01" : [MLMyFavoritesViewController class],
								 @"SS01" : [MLStoresSearchResultViewController class]
								 };
	Class class = nil;
	if (_redirectType) {
		class = dictionary[_pageCode.uppercaseString];
		if (class == [MLStoresSearchResultViewController class]) {
			if (!_parameterID.length) {//如果参数为空则进入选择分类的界面
				class = [MLStoreClassifiesViewController class];
			}
		}
	}
	return class;
}

@end
