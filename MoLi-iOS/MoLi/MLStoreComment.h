//
//  MLStoreComment.h
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 商品评论信息.
@interface MLStoreComment : ZBModel

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *star;

@end
