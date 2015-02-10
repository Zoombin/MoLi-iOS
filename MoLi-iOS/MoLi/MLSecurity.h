//
//  MLSecurity.h
//  MoLi
//
//  Created by zhangbin on 11/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLSecurity : ZBModel <NSCoding>

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appSecret;

@end
