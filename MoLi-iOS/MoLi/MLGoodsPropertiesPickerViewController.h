//
//  MLGoodsPropertiesPickerViewController.h
//  MoLi
//
//  Created by zhangbin on 1/19/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

typedef NS_ENUM(NSUInteger, MLGoodsPropertiesPickerViewStyle) {
	MLGoodsPropertiesPickerViewStyleNormal,
	MLGoodsPropertiesPickerViewStyleAddCart,
	MLGoodsPropertiesPickerViewStyleDirectlyBuy
};

@interface MLGoodsPropertiesPickerViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MLGoods *goods;

- (void)createUIs;
+ (CGFloat)indent;

@end
