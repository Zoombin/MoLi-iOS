//
//  MLPushParamsEntity.h
//  MoLi
//
//  Created by yc on 15-4-20.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLPushParamsEntity : ZBModel
//public String goodsid;
//public String fstoreid;
//public String estoreid;
//public String bclassifyid;
@property (nonatomic, strong) NSString *goodsid;
@property (nonatomic, strong) NSString *fstoreid;
@property (nonatomic, strong) NSString *estoreid;
@property (nonatomic, strong) NSString *bclassifyid;
@end
