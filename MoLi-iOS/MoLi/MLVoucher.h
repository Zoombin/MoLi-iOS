//
//  MLVoucher.h
//  MoLi
//
//  Created by zhangbin on 1/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLVoucher : ZBModel

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *voucherWillGet;
@property (nonatomic, strong) NSNumber *voucherCanCost;
@property (nonatomic, strong) NSString *orderNO;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSArray *voucherWillGetRange;

@end
