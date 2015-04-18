//
//  MLMemberCard.h
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 会员卡信息.
@interface MLMemberCard : ZBModel

@property (nonatomic, strong) NSNumber *expireSeconds;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong, getter=isVIP) NSNumber *VIP;
@property (nonatomic, strong) NSString *QRCodeImagePath;
@property (nonatomic, strong) NSString *barImagePath;

@end
