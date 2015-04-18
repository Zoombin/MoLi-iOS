//
//  MLOrderAddress.h
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 订单地址.
@interface MLOrderAddress : ZBModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, strong) NSString *telephone;
@end
