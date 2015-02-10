//
//  MLCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLCollectionViewCell.h"
#import "Header.h"

@implementation MLCollectionViewCell

- (void)setAdvertisement:(MLAdvertisement *)advertisement {
	_advertisement = advertisement;
}

- (void)setAdvertisementElement:(MLAdvertisementElement *)advertisementElement {
	_advertisementElement = advertisementElement;
}

@end
