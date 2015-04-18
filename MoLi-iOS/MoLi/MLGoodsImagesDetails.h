//
//  MLGoodsImagesDetails.h
//  MoLi
//
//  Created by zhangbin on 12/22/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 商品图文详情.
@interface MLGoodsImagesDetails : ZBModel

@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *imagePaths;
@property (nonatomic, strong) NSString *link;

@end
