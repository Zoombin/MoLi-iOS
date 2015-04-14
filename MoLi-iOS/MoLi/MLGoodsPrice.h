//
//  MLGoodsPrice.h
//  MoLi
//
//  Created by zhangbin on 4/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLGoodsPrice : ZBModel

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *isVoucher;//是否有赠送代金券
@property (nonatomic, strong) NSNumber *voucher;
@property (nonatomic, strong) NSNumber *stock;

@end
