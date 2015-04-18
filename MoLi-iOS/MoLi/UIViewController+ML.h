//
//  UIViewController+ML.h
//  MoLi
//
//  Created by zhangbin on 1/30/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ZBUtilites.h"
#import "MLResponse.h"

/// viewController工具类.
@interface UIViewController (ML)

- (void)setLeftBarButtonItemAsBackToRootArrowButton;
- (void)setLeftBarButtonItemAsBackArrowButton;
- (void)displayResponseMessage:(MLResponse *)response;

@end
