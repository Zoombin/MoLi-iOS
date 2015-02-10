//
//  MLFavoritesViewController.h
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLFavoriteType) {
	MLFavoriteTypeGoods,
	MLFavoriteTypeFlagshipStore,
	MLFavoriteTypeStore
};

@interface MLFavoritesViewController : UIViewController

@property (nonatomic, assign) MLFavoriteType favoriteType;

@end
