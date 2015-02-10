//
//  MLGoodsClassify.h
//  MoLi
//
//  Created by zhangbin on 12/9/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLGoodsClassify : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSArray *subClassifies;

@end
