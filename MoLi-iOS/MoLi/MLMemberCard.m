//
//  MLMemberCard.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMemberCard.h"

@implementation MLMemberCard

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_expireSeconds = [attributes[@"expiresec"] notNull];
		_message = [attributes[@"showmsg"] notNull];
		_VIP = [attributes[@"vipflag"] notNull];
		if ([attributes[@"barcode"] notNull]) {
			if ([attributes[@"barcode"][@"show"] boolValue]) {
				_barImagePath = attributes[@"barcode"][@"image"];
			}
		}
		if ([attributes[@"qrcode"] notNull]) {
			if ([attributes[@"qrcode"][@"show"] boolValue]) {
				_QRCodeImagePath = attributes[@"qrcode"][@"image"];
			}
		}
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<expireSecondes:%@, message:%@, VIP:%@, barImagePath:%@, QRCodeImagePath:%@>", _expireSeconds, _message, _VIP, _barImagePath, _QRCodeImagePath];
}

@end
