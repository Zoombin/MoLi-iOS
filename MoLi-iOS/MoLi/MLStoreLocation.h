//
//  MLStoreLocation.h
//  MoLi
//
//  Created by 颜超 on 15/2/1.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLStoreLocation : ZBModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *businessicon;
@property (nonatomic, strong) NSString *businessid;
@property (nonatomic, strong) NSString *businessname;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSArray *industryid;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *telephone;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
