//
//  MLVoucher.h
//  MoLi
//
//  Created by zhangbin on 1/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 代金券信息.
@interface MLVoucher : ZBModel

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *voucherWillGet;
@property (nonatomic, strong) NSNumber *voucherCanCost;
@property (nonatomic, strong) NSString *orderNO;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSArray *voucherWillGetRange;
@property (nonatomic, strong) NSNumber *voucherWillingUse;//将要使用的金额，提交订单时候使用

@end
