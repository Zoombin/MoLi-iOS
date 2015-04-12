//
//  ZBViewController.h
//  BookReader
//
//  Created by zhangbin on 8/2/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBViewController : UIViewController

@property (nonatomic, strong) UITapGestureRecognizer *hideKeyboardRecognzier;

- (void)hideKeyboard;
- (void)backOrClose;
- (void)backToRoot;

@end
