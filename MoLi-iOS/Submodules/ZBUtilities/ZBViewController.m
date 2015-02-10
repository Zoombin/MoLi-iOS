//
//  ZBViewController.m
//  BookReader
//
//  Created by zhangbin on 8/2/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "ZBViewController.h"

@interface ZBViewController ()

@end

@implementation ZBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_hideKeyboardRecognzier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:_hideKeyboardRecognzier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backOrClose
{
	if (self.navigationController.viewControllers[0] != self) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if (self.navigationController.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)hideKeyboard
{
	[self.view endEditing:YES];
}

@end
