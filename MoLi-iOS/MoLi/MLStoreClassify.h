//
//  MLStoreClassify.h
//  MoLi
//
//  Created by zhangbin on 1/28/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 商铺分类.
@interface MLStoreClassify : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *smallImagePath;
@property (nonatomic, strong) NSString *smallHighlightedImagePath;
@property (nonatomic, strong) NSArray *subClassifies;

@end
