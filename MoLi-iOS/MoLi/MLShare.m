//
//  MLShare.m
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLShare.h"

@implementation MLShare

+ (NSString *)identifierForShareObject:(MLShareObject)shareObject {
	NSDictionary *shareObjects = @{
								   @(MLShareObjectGoods) : @"goods",
								   @(MLShareObjectEStore) : @"estore",
								   @(MLShareObjectFStore) : @"fstore",
								   @(MLShareObjectAPP) : @"app",
								   };
	return shareObjects[@(shareObject)];
}

+ (NSString *)identifierForSHarePlayform:(MLSharePlatform)sharePlatform {
	NSDictionary *sharePlatforms = @{
								   @(MLSharePlatformQQ) : @"qqmsg",
								   @(MLSharePlatformQZone) : @"qzone",
								   @(MLSharePlatformWeChatCircle) : @"wxmsg",
								   @(MLSharePlatformWeChatMessage) : @"wxcircle",
								   @(MLSharePlatformWeibo) : @"weibo",
								   };
	return sharePlatforms[@(sharePlatform)];
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_type = [attributes[@"stype"] notNull];
		_title = [attributes[@"title"] notNull];
		_word = [attributes[@"word"] notNull];
		_imagePath = [attributes[@"image"] notNull];
		_link = [attributes[@"link"] notNull];
	}
	return self;
}

+ (NSDictionary *)parameterWithShareObject:(MLShareObject)shareObject objectID:(id)objectID {
	if (!objectID) {
		return @{};
	}
	if (shareObject == MLShareObjectEStore) {
		return @{@"estoreid" : objectID};
	} else if (shareObject == MLShareObjectFStore) {
		return @{@"fstoreid" : objectID};
	} else if (shareObject == MLShareObjectGoods) {
		return @{@"goodsid" : objectID};
	} else {
		return @{};
	}
}

@end
