//
//  MLSellerInfo.h
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 卖家信息.
@interface MLSellerInfo : ZBModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;

@end
