//
//  UIViewController+ML.m
//  MoLi
//
//  Created by zhangbin on 1/30/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIViewController+ML.h"
#import "Header.h"

@implementation UIViewController (ML)

- (void)setLeftBarButtonItemAsBackArrowButton {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"BackArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backOrClose)];
}

- (void)displayResponseMessage:(MLResponse *)response {
	if (response.message) {
		[self displayHUDTitle:nil message:response.message];
	} else {
		[self hideHUD:YES];
	}
}

@end
