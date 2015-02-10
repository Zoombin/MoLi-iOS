//
//  MLFavoriteSummary.h
//  MoLi
//
//  Created by zhangbin on 2/6/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLFavoriteSummary : ZBModel

@property (nonatomic, strong) NSNumber *numberOfgoods;
@property (nonatomic, strong) NSNumber *numberOfFlagshipStore;
@property (nonatomic, strong) NSNumber *numberOfStore;

- (NSNumber *)total;

@end
