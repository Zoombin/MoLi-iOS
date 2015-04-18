//
//  MLPickAreaViewController.h
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLProvince.h"
#import "MLCity.h"
#import "MLArea.h"

@protocol MLAreasViewControllerDelegate <NSObject>

- (void)pickProvince:(MLProvince *)province city:(MLCity *)city area:(MLArea *)area;

@end

/// 选择区域 省份 城市.
@interface MLAreasViewController : UIViewController

@property (nonatomic, weak) id <MLAreasViewControllerDelegate> delegate;
@property (nonatomic, strong) MLProvince *province;
@property (nonatomic, strong) MLCity *city;

@end
