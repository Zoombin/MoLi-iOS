//
//  MLOrderOperator.h
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

typedef NS_ENUM(NSUInteger, MLOrderOperatorType) {
	MLOrderOperatorTypeCancel,
	MLOrderOperatorTypeDelete,
	MLOrderOperatorTypePay,
	MLOrderOperatorTypeNotice,
	MLOrderOperatorTypeLogistic,
	MLOrderOperatorTypeConfirm,
	MLOrderOperatorTypeVoucher,
	MLOrderOperatorTypeComment,
	MLOrderOperatorTypeDelay,
	MLOrderOperatorTypeAfterSalesService,
	MLOrderOperatorTypeAfterSalesServiceLogistic,
	MLOrderOperatorTypeAfterSalesServiceCancel,
};

/// 订单操作集信息.
@interface MLOrderOperator : ZBModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *backgroundHexColor;
@property (nonatomic, strong) NSString *fontHexColor;
@property (nonatomic, assign) MLOrderOperatorType type;

+ (NSString *)identifierForType:(MLOrderOperatorType)type;
+ (NSString *)methodNameForType:(MLOrderOperatorType)type;
+ (Class)classForType:(MLOrderOperatorType)type;

@end
