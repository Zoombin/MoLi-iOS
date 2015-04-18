//
//  MLFlagshipStore.h
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 旗舰店信息.
@interface MLFlagshipStore : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *favorites;//是否收藏

@end
