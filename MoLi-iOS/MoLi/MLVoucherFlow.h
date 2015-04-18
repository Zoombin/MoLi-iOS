//
//  MLVoucherFlow.h
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

typedef NS_ENUM(NSUInteger, MLVoucherFlowType) {
	MLVoucherFlowTypeAll,
	MLVoucherFlowTypeGet,
	MLVoucherFlowTypeUse
};

/// 代金券信息.
@interface MLVoucherFlow : ZBModel

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *amount;

@end
