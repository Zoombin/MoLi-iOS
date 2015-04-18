//
//  MLNearbyStoresListViewController.h
//  MoLi
//
//  Created by 颜超 on 15/2/1.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

/// 附近的商铺.
@interface MLNearbyStoresListViewController : UIViewController {

}
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) BMKMapView *baiduMapView;
@end
