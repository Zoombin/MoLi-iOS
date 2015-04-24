//
//  MLGoodsPropertiesPickerViewController.h
//  MoLi
//
//  Created by zhangbin on 1/19/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

@protocol MLGoodsPropertiesPickerViewControllerDelegate <NSObject>

- (void)willBuyGoods:(MLGoods *)goods;

@end

typedef NS_ENUM(NSUInteger, MLGoodsPropertiesPickerViewStyle) {
	MLGoodsPropertiesPickerViewStyleNormal,
	MLGoodsPropertiesPickerViewStyleAddCart,
	MLGoodsPropertiesPickerViewStyleDirectlyBuy
};

/// 规格选择.
@interface MLGoodsPropertiesPickerViewController : UIViewController

@property (nonatomic, weak) id <MLGoodsPropertiesPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MLGoods *goods;

- (void)createUIs;
+ (CGFloat)indent;

@end
