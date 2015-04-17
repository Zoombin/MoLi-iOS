//
//  MLOrderOperator.m
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLOrderOperator.h"
#import "MLAskForAfterSalesViewController.h"
#import "MLPaymentViewController.h"
#import "MLAfterSalesLogisticViewController.h"
#import "MLNewVoucherViewController.h"

@implementation MLOrderOperator

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
	self = [super initWithAttributes:attributes];
	if (self) {
		_name = [attributes[@"name"] notNull];
		_code = [attributes[@"code"] notNull];
		_backgroundHexColor = [attributes[@"bgcolor"] notNull];
		_fontHexColor = [attributes[@"fontcolor"] notNull];
		
		if ([_code.uppercaseString isEqualToString:@"OP001"]) {
			_type = MLOrderOperatorTypeCancel;
		} else if ([_code.uppercaseString isEqualToString:@"OP002"]) {
			_type = MLOrderOperatorTypeDelete;
		} else if ([_code.uppercaseString isEqualToString:@"OP003"]) {
			_type = MLOrderOperatorTypePay;
		} else if ([_code.uppercaseString isEqualToString:@"OP004"]) {
			_type = MLOrderOperatorTypeNotice;
		} else if ([_code.uppercaseString isEqualToString:@"OP005"]) {
			_type = MLOrderOperatorTypeLogistic;
		} else if ([_code.uppercaseString isEqualToString:@"OP006"]) {
			_type = MLOrderOperatorTypeConfirm;
		} else if ([_code.uppercaseString isEqualToString:@"OP007"]) {
			_type = MLOrderOperatorTypeVoucher;
		} else if ([_code.uppercaseString isEqualToString:@"OP008"]) {
			_type = MLOrderOperatorTypeComment;
		} else if ([_code.uppercaseString isEqualToString:@"OP009"]) {
			_type = MLOrderOperatorTypeDelay;
		} else if ([_code.uppercaseString isEqualToString:@"OP011"]) {//申请售后
			_type = MLOrderOperatorTypeAfterSalesService;
		} else if ([_code.uppercaseString isEqualToString:@"OP012"]) {//填写物流信息
			_type = MLOrderOperatorTypeAfterSalesServiceLogistic;
		} else if ([_code.uppercaseString isEqualToString:@"OP013"]) {//取消售后
			_type = MLOrderOperatorTypeAfterSalesServiceCancel;
		}
#warning TODO: 还有一些操作没有列全
	}
	return self;
}

+ (NSString *)identifierForType:(MLOrderOperatorType)type {
	if (type == MLOrderOperatorTypeDelay) {
		return @"takedelay";
	} else if (type == MLOrderOperatorTypeCancel) {
		return @"cancel";
	} else if (type == MLOrderOperatorTypeDelete) {
		return @"delete";
	} else if (type == MLOrderOperatorTypePay) {
		return @"pay";
	} else if (type == MLOrderOperatorTypeNotice) {
		return @"notice";
	} else if (type == MLOrderOperatorTypeLogistic) {
		return @"logistic";
	} else if (type == MLOrderOperatorTypeConfirm) {
		return @"take";
	} else if (type == MLOrderOperatorTypeComment) {
		return @"comment";
	} else if (type == MLOrderOperatorTypeAfterSalesService) {
		return @"service";
	} else if (type == MLOrderOperatorTypeAfterSalesServiceCancel) {
		return @"servicecancel";
	}
	return nil;
}

+ (NSString *)methodNameForType:(MLOrderOperatorType)type {
	if (type == MLOrderOperatorTypeLogistic) {
		return @"GET";
	} else if (type == MLOrderOperatorTypeComment) {
		return @"GET";
	}
	return @"POST";
}

+ (Class)classForType:(MLOrderOperatorType)type {
	if (type == MLOrderOperatorTypeAfterSalesService) {
		return [MLAskForAfterSalesViewController class];
	} else if (type == MLOrderOperatorTypePay) {
		return [MLPaymentViewController class];
	} else if (type == MLOrderOperatorTypeAfterSalesServiceLogistic) {
		return [MLAfterSalesLogisticViewController class];
	} else if (type == MLOrderOperatorTypeVoucher) {
		return [MLNewVoucherViewController class];
	}
	return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<name:%@, code:%@>", _name, _code];
}

@end
