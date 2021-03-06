//
//  MLLogistic.h
//  MoLi
//
//  Created by zhangbin on 1/21/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 物流信息.
@interface MLLogistic : ZBModel

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shippingNO;
@property (nonatomic, strong) NSString *linkURLString;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *time;

@end
