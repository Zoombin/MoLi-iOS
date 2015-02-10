//
//  MLStore.h
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MLStore : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *businessCategory;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *starRated;
@property (nonatomic, strong) NSNumber *commentsNumber;
@property (nonatomic, strong) NSArray *phones;

+ (UIImage *)imageByStoreCategory:(NSString *)category;

@end
