//
//  MLResponse.m
//  MoLi
//
//  Created by zhangbin on 1/24/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLResponse.h"

@interface MLResponse ()

@property (readwrite) NSError *error;

@end

@implementation MLResponse

- (instancetype)initWithResponseObject:(id)responseObject {
	self = [super init];
	if (self) {
		NSNumber *flag = [responseObject valueForKeyPath:@"error"];
		if (flag.integerValue == 0) {
			_success = YES;
			_data = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
			if (_data && [_data isKindOfClass:[NSDictionary class]]) {
				_message = _data[@"message"];
				if (!_message.length) {
					_message = nil;
				}
			}
		} else {
			_message = [[responseObject valueForKeyPath:@"msg"] notNull];
			if (!_message.length) {
				_message = [[responseObject valueForKey:@"showmsg"] notNull];
				if (!_message.length) {
					_message = @"未知错误";
				}
			}
		}
	}
	return self;
}


@end
