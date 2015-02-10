//
//  UIViewController+ZBUtilites.m
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "UIViewController+ZBUtilites.h"

@implementation UIViewController (ZBUtilites)

- (void)setLeftBarButtonItemAsBackButton
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backOrClose)];
}

- (void)setLeftBarButtonItemAsBackButtonToRoot
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backOrCloseToRoot)];
}

- (void)setRightBarButtonItemAsSaveButtonWithSelector:(SEL)selector
{
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:selector];
}

- (void)setRightBarButtonItemAsSendButtonWithSelector:(SEL)selector
{
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"发送", nil) style:UIBarButtonItemStylePlain target:self action:selector];
}

- (void)backOrClose
{
	if (self.navigationController.viewControllers[0] != self) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if (self.navigationController.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)backOrCloseToRoot
{
	if (self.navigationController.viewControllers[0] != self) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else if (self.navigationController.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

@end
