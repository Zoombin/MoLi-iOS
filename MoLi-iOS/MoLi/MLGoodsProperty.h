//
//  MLGoodsProperty.h
//  MoLi
//
//  Created by zhangbin on 12/20/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLGoodsProperty : ZBModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSNumber *selectedIndex;

@end
