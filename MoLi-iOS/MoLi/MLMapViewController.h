//
//  MLMapViewController.h
//  MoLi
//
//  Created by yc on 15-1-30.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MLStore.h"
#import "MLCity.h"

@interface MLMapViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKRouteSearch *searcher;
@property (nonatomic, strong) MLStore *store;
@property (nonatomic, strong) MLCity *city;

@end
