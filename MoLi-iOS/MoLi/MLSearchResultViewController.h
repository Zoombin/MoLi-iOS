//
//  MLSearchViewController.h
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoodsClassify.h"

/// 搜索结果页面.
@interface MLSearchResultViewController : UIViewController

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) MLGoodsClassify *goodsClassify;
@property (nonatomic, assign) BOOL popTargetIsRoot;

@end
