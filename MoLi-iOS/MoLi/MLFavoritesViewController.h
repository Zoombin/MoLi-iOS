//
//  MLFavoritesViewController.h
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLFavoriteType) {
	MLFavoriteTypeGoods, // 商品收藏
	MLFavoriteTypeFlagshipStore, // 旗舰店收藏
	MLFavoriteTypeStore // 实体店收藏
};

/// 我的收藏.
@interface MLFavoritesViewController : UIViewController

@property (nonatomic, assign) MLFavoriteType favoriteType;

@end
