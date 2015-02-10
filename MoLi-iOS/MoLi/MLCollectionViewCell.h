//
//  MLCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAdvertisement.h"
#import "MLAdvertisementElement.h"

@protocol MLCollectionViewCellDelegate <NSObject>

- (void)collectionViewCellWillSelectAdvertisement:(MLAdvertisement *)advertisement advertisementElement:(MLAdvertisementElement *)advertisementElement;

@end

@interface MLCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <MLCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) MLAdvertisement *advertisement;
@property (nonatomic, strong) MLAdvertisementElement *advertisementElement;

@end
