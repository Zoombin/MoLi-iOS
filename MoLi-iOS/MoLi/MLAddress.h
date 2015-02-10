//
//  MLAddress.h
//  MoLi
//
//  Created by zhangbin on 1/13/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLAddress : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSNumber *provinceID;
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSNumber *areaID;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSNumber *isDefault;

@end
