//
//  UIViewController+ZBUtilites.h
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZBUtilites)

- (void)setLeftBarButtonItemAsBackButton;
- (void)setLeftBarButtonItemAsBackButtonToRoot;
- (void)backOrClose;
- (void)backOrCloseToRoot;
- (void)setRightBarButtonItemAsSaveButtonWithSelector:(SEL)selector;
- (void)setRightBarButtonItemAsSendButtonWithSelector:(SEL)selector;

@end
