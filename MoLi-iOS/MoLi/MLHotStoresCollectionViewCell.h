//
//  MLHotStoresCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/27/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCollectionViewCell.h"
#import "MLAdvertisement.h"

/// 热门店铺的collectioncell.
@interface MLHotStoresCollectionViewCell : MLCollectionViewCell

@property (nonatomic, strong) NSArray *advertisements;

@end
