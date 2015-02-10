//
//  MLPickProvinceViewController.h
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLProvince.h"
#import "MLCity.h"
#import "MLArea.h"

@protocol MLProvincesViewControllerDelegate <NSObject>

- (void)pickProvince:(MLProvince *)provice city:(MLCity *)city area:(MLArea *)area;

@end

@interface MLProvincesViewController : UIViewController

@property (nonatomic, weak) id <MLProvincesViewControllerDelegate> delegate;

@end
