//
//  MLStoresSearchResultViewController.h
//  MoLi
//
//  Created by zhangbin on 1/27/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCity.h"

/// 实体店搜索结果页面.
@interface MLStoresSearchResultViewController : UIViewController

@property (nonatomic, strong) MLCity *city;
@property (nonatomic, strong) NSString *classifyID;
@property (nonatomic, strong) NSString *searchString;

@end
