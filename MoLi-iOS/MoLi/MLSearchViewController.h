//
//  MLSearchViewController.h
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 搜索页面.
@interface MLSearchViewController : UIViewController

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign) BOOL isSearchStores;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, assign) BOOL popTargetIsRoot;

@end
