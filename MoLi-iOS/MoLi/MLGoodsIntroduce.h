//
//  MLGoodsIntroduce.h
//  MoLi
//
//  Created by zhangbin on 1/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLGoodsIntroduceElement.h"

@interface MLGoodsIntroduce : ZBModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *elements;

@end
