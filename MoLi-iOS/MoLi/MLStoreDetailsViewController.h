//
//  MLStoreDetailsViewController.h
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLStore.h"
#import "MLCity.h"

/// 实体店详情.
@interface MLStoreDetailsViewController : UIViewController

@property (nonatomic, strong) MLStore *store;
@property (nonatomic, strong) MLCity *city;

@end
