//
//  MLNearbyStoresListViewController.m
//  MoLi
//
//  Created by 颜超 on 15/2/1.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLNearbyStoresListViewController.h"
#import "Header.h"
#import "MLStoreLocation.h"

@interface MLNearbyStoresListViewController ()

@end

@implementation MLNearbyStoresListViewController {
    NSMutableArray *shopsArray;
    BMKLocationService* _locService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shopsArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = NSLocalizedString(@"附近的商铺", nil);
    [self setLeftBarButtonItemAsBackArrowButton];
    
    _baiduMapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_baiduMapView];
    
    [self startLocation];
    [self loadNearByStore];
}

//普通
- (void)startLocation {
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _baiduMapView.showsUserLocation = YES;//显示定位图层
}

- (void)loadNearByStore {
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] nearByStoreList:_cityId withBlock:^(NSArray *attributes, NSError *error) {
        [self hideHUD:YES];
        if (!error) {
            NSLog(@"%@", attributes);
            if ([attributes count] > 0) {
                for (int i = 0; i < [attributes count]; i++) {
                    MLStoreLocation *location = [[MLStoreLocation alloc] initWithAttributes:attributes[i]];
                    [shopsArray addObject:location];
                }
                [self addPoint];
            }
        } else {
            NSLog(@"数据加载失败...");
        }
    }];
}

- (void)addPoint {
    for (MLStoreLocation *location in shopsArray) {
        if ([location.address isEqualToString:@""]) {
            continue;
        }
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [location.lat doubleValue];
        coor.longitude = [location.lng doubleValue];
        annotation.coordinate = coor;
        annotation.title = location.businessname;
        [_baiduMapView addAnnotation:annotation];
        [_baiduMapView setCenterCoordinate:coor animated:YES];
    }
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser {
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [_baiduMapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_baiduMapView updateLocationData:userLocation];
    [_baiduMapView setCenterCoordinate:userLocation.location.coordinate];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser {
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"location error");
}


- (void)dealloc {
    _baiduMapView = nil;
}

@end
