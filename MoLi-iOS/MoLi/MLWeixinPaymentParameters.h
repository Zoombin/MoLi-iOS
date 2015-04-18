//
//  MLWeixinPaymentParameters.h
//  MoLi
//
//  Created by zhangbin on 4/14/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 微信付款参数.
@interface MLWeixinPaymentParameters : ZBModel

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *nonceString;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *partnerID;
@property (nonatomic, strong) NSString *prepayID;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *timestampString;
@property (nonatomic, strong) NSString *appKey;

@end
