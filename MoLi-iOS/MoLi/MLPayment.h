//
//  MLPayment.h
//  MoLi
//
//  Created by zhangbin on 4/12/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 付款信息.
@interface MLPayment : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSArray *orderIDs;
@property (nonatomic, strong) NSNumber *totalPrice;//订单商品总金额
@property (nonatomic, strong) NSNumber *payAmount;//需要支付的现金总金额 显示在选择支付方式界面
@property (nonatomic, strong) NSNumber *payVoucher;//已经支付的代金券总金额
@property (nonatomic, strong) NSString *paySubject;//支付标题 例：魔力商城订单
@property (nonatomic, strong) NSString *payBody;//支付描述
@property (nonatomic, strong) NSNumber *VIP;

@end
