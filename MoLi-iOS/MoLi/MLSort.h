//
//  MLSort.h
//  MoLi
//
//  Created by zhangbin on 1/28/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 排序信息.
typedef NS_ENUM(NSUInteger, MLSortType) {
	MLSortTypeDistance,
	MLSortTypeTime
};

@interface MLSort : ZBModel

@end
