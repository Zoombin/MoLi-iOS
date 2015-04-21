//
//  MLGlobal.h
//  MoLi
//
//  Created by LLToo on 15/4/21.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLAppInfo.h"

@interface MLGlobal : NSObject

@property (nonatomic,strong) MLAppInfo *appInfo;

@property (nonatomic,strong) NSString *voucherterm;  //代金券使用细则

+ (instancetype)shared;

- (void)fetchGlobalData;


@end
