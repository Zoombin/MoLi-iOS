//
//  MLAdvertisement.h
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLAdvertisementElement.h"

typedef NS_ENUM(NSUInteger, MLAdvertisementType) {
	MLAdvertisementTypeBanner,
	MLAdvertisementTypeShortcut,
	MLAdvertisementTypeNormal,
	MLAdvertisementTypeHot
};

@interface MLAdvertisement : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *elements;

+ (MLAdvertisement *)advertisementOfType:(MLAdvertisementType)type inAdvertisements:(NSArray *)advertisements;
+ (NSArray *)severalAdvertisementsOfType:(MLAdvertisementType)type inAdvertisements:(NSArray *)advertisements;
- (MLAdvertisementType)advertisementType;

@end
