//
//  MLUser.h
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 用户信息.
@interface MLUser : ZBModel

@property (nonatomic, strong) NSData *avatarData;
@property (nonatomic, strong) NSString *avatarURLString;
@property (nonatomic, strong) NSString *bindingBusiness;
@property (nonatomic, strong) NSString *bindingBusinessID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSString *signToken;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userRole;

@end
