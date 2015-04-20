//
//  MLPushEntity.h
//  MoLi
//
//  Created by yc on 15-4-20.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLPushEntity : ZBModel
//public String activity;// app/page/link,
//public String pagecode;
//public ParamsEty param;
//public String url;
@property (nonatomic, strong) NSString *activity; // app/page/link,
@property (nonatomic, strong) NSString *pagecode;
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) NSString *url;
@end
