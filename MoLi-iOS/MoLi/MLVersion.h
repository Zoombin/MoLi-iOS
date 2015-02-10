//
//  MLVersion.h
//  MoLi
//
//  Created by zhangbin on 11/17/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLVersion : ZBModel

@property (nonatomic, strong) NSNumber *hasNewVersion;
@property (nonatomic, strong) NSString *latestVersion;
@property (nonatomic, strong) NSNumber *forceUpdate;
@property (nonatomic, strong) NSString *updateURLString;
@property (nonatomic, strong) NSString *describe;

@end
