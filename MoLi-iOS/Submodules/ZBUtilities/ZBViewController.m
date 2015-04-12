//
//  ZBViewController.m
//  BookReader
//
//  Created by zhangbin on 8/2/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "ZBViewController.h"

@implementation ZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_hideKeyboardRecognzier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:_hideKeyboardRecognzier];
}

- (void)backOrClose {
	if (self.navigationController.viewControllers[0] != self) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if (self.navigationController.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)backToRoot {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

@end
