//
//  MLAppInfo.h
//  MoLi
//
//  Created by 颜超 on 15/1/31.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBModel.h"

@interface MLAppInfo : ZBModel

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *copyright;
@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSString *usehelp;
@property (nonatomic, strong) NSString *vipuserterms;
@property (nonatomic, strong) NSArray *vipuserprotocol;
@property (nonatomic, strong) NSString *versiondesc;

@end
