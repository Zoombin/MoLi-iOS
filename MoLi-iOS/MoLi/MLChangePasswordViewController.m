//
//  MLChangePasswordViewController.m
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLChangePasswordViewController.h"
#import "MLTextField.h"
#import "Header.h"

@interface MLChangePasswordViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLTextField *currentPasswordTextField;
@property (readwrite) MLTextField *passwordTextField;
@property (readwrite) MLTextField *passwordConfirmTextField;

@end

@implementation MLChangePasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"修改密码";
	if (_isWalletPassword) {
		self.title = @"修改交易密码";
	}
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
	
	CGRect rect = CGRectZero;
	rect.origin.y = edgeInsets.top;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 46;
	_currentPasswordTextField = [[MLTextField alloc] initWithFrame:rect];
	_currentPasswordTextField.secureTextEntry = YES;
	_currentPasswordTextField.placeholder = @"请输入当前密码";
	if (_isWalletPassword) {
		_currentPasswordTextField.placeholder = @"请输入当前交易密码";
	}
	[_scrollView addSubview:_currentPasswordTextField];
	
	rect.origin.y = CGRectGetMaxY(_currentPasswordTextField.frame);
	rect.size.height = 0.5;
	[_scrollView addSubview:[UIView borderLineWithFrame:rect]];
	
	rect.origin.y = CGRectGetMaxY(_currentPasswordTextField.frame) + 0.5;
	rect.size.height = CGRectGetHeight(_currentPasswordTextField.frame);
	_passwordTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordTextField.secureTextEntry = YES;
	_passwordTextField.placeholder = @"请输入新密码";
	if (_isWalletPassword) {
		_passwordTextField.placeholder = @"设置新的交易密码";
	}
	[_scrollView addSubview:_passwordTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordTextField.frame);
	rect.size.height = 0.5;
	[_scrollView addSubview:[UIView borderLineWithFrame:rect]];
	
	rect.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 0.5;
	rect.size.height = CGRectGetHeight(_passwordTextField.frame);
	_passwordConfirmTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordConfirmTextField.placeholder = @"请再次输入新密码";
	if (_isWalletPassword) {
		_passwordConfirmTextField.placeholder = @"确认新的交易密码";
	}
	_passwordConfirmTextField.secureTextEntry = YES;
	[_scrollView addSubview:_passwordConfirmTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordConfirmTextField.frame) + edgeInsets.bottom;
	UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	submitButton.frame = rect;
	[submitButton setTitle:@"保存" forState:UIControlStateNormal];
	[submitButton setBackgroundColor:[UIColor themeColor]];
	[submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:submitButton];
}

- (void)submit {
	if (!_currentPasswordTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入当前密码"];
		return;
	}
	
	if (!_passwordTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入新密码"];
		return;
	}
	
	if (!_passwordConfirmTextField.text.length) {
		[self displayHUDTitle:nil message:@"请再次输入新密码"];
		return;
	}
	
	if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
		[self displayHUDTitle:nil message:@"新密码两次输入不同"];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	if (_isWalletPassword) {
		[[MLAPIClient shared] updateWalletPassword:_passwordTextField.text passwordConfirm:_passwordConfirmTextField.text currentPassword:_currentPasswordTextField.text withBlock:^(MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				[self.navigationController popViewControllerAnimated:YES];
			}
		}];
	} else {
		[[MLAPIClient shared] changeOldPassword:_currentPasswordTextField.text newPassword:_passwordTextField.text newPasswordConfirm:_passwordConfirmTextField.text withBlock:^(MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				[self.navigationController popViewControllerAnimated:YES];
			}
		}];
	}

}

@end
