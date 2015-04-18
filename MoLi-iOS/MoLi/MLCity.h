//
//  MLCity.h
//  MoLi
//
//  Created by zhangbin on 12/11/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLArea.h"

/// 城市信息.
@interface MLCity : ZBModel

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *areas;

@end
