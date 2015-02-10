//
//  MLOrderResult.h
//  MoLi
//
//  Created by zhangbin on 1/21/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLOrderResult : ZBModel

@property (nonatomic, strong) NSArray *multiNO;
@property (nonatomic, strong) NSNumber *payAmount;
@property (nonatomic, strong) NSString *payNO;
@property (nonatomic, strong) NSNumber *payVoucher;
@property (nonatomic, strong) NSNumber *VIP;

@end
