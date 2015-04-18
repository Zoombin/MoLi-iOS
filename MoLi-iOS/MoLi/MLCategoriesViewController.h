//
//  MLCategoriesViewController.h
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNoDataView.h"

/// 分类.
@interface MLCategoriesViewController : UIViewController <MLNoDataViewDelegate>

- (void)showMainCategoriesOnly;

@end
