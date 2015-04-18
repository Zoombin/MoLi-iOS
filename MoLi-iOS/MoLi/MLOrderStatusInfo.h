//
//  MLOrderStatusInfo.h
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 订单状态信息.
@interface MLOrderStatusInfo : ZBModel

@property (nonatomic, strong) NSString *current;
@property (nonatomic, strong) NSArray *log;
@end
