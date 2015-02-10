//
//  UIViewController+HUD.h
//
//  Created by Rex Sheng on 10/11/12.
//  Copyright (c) 2012 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)displayHUD:(NSString *)text;
- (void)hideHUD:(BOOL)animated;
- (void)displayHUDError:(NSString *)title message:(NSString *)message __deprecated;//命名不太好，不一定用于显示error的，所以用下面的方法替代
- (void)displayHUDTitle:(NSString *)title message:(NSString *)message;
- (void)displayHUDTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)duration;

@end
