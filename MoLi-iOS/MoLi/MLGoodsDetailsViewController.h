//
//  MLGoodsDetailsViewController.h
//  MoLi
//
//  Created by zhangbin on 12/20/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"
#import "MLGoodsPropertiesPickerViewController.h"

/// 商品详情.
@interface MLGoodsDetailsViewController : UIViewController

@property (nonatomic, strong) MLGoods *goods;
@property (nonatomic, strong) MLGoodsPropertiesPickerViewController *propertiesPickerViewController;
@property (nonatomic, assign) BOOL previousViewControllerHidenBottomBar;

@end
