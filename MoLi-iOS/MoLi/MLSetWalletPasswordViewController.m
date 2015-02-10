//
//  MLSetWalletPasswordViewController.m
//  MoLi
//
//  Created by zhangbin on 2/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLSetWalletPasswordViewController.h"
#import "Header.h"
#import "MLTextField.h"

@interface MLSetWalletPasswordViewController ()

@property (readwrite) MLTextField *passwordTextField;
@property (readwrite) MLTextField *passwordConfirmTextField;
@property (readwrite) UIButton *submitButton;

@end

@implementation MLSetWalletPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"设置交易密码";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	CGRect rect = self.view.bounds;
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
	[self.view addSubview:scrollView];
	
	rect.origin.y = 20;
	rect.size.height = 46;
	
	_passwordTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordTextField.placeholder = @"设置交易密码";
	_passwordTextField.secureTextEntry = YES;
	[scrollView addSubview:_passwordTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordTextField.frame);
	rect.size.height = 0.5;
	[scrollView addSubview:[UIView borderLineWithFrame:rect]];
	
	rect.origin.y += 0.5;
	rect.size.height = _passwordTextField.bounds.size.height;
	_passwordConfirmTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordConfirmTextField.placeholder = @"确认交易密码";
	_passwordConfirmTextField.secureTextEntry = YES;
	[scrollView addSubview:_passwordConfirmTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordConfirmTextField.frame) + 10;
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = rect;
	_submitButton.backgroundColor = [UIColor themeColor];
	[_submitButton setTitle:@"确认" forState:UIControlStateNormal];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:_submitButton];
	
	rect.origin.x = ML_COMMON_EDGE_LEFT;
	rect.origin.y = CGRectGetMaxY(_submitButton.frame) + 10;
	rect.size.width = self.view.bounds.size.width - rect.origin.x - ML_COMMON_EDGE_LEFT;
	rect.size.height = 20;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.textColor = [UIColor themeColor];
	label.text = @"温馨提示";
	label.font = [UIFont systemFontOfSize:12];
	[scrollView addSubview:label];
	
	rect.origin.y = CGRectGetMaxY(label.frame);
	rect.size.height = 30;
	UILabel *describeLabel = [[UILabel alloc] initWithFrame:rect];
	describeLabel.numberOfLines = 0;
	describeLabel.font = [UIFont systemFontOfSize:10];
	describeLabel.textColor = [UIColor fontGrayColor];
	describeLabel.text = @"交易密码用来确认收货和代金券支付，与下单时的现金支付无关，请妥善保管！";
	[scrollView addSubview:describeLabel];
}

- (void)submit {
	if (!_passwordConfirmTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入确认交易密码"];
		return;
	}
	
	if (!_passwordTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入交易密码"];
		return;
	}
	
	if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
		[self displayHUDTitle:nil message:@"两次密码输入不同"];
		return;
	}
	
	[self displayHUDTitle:nil message:@"加载中..."];
	[[MLAPIClient shared] updateWalletPassword:_passwordTextField.text passwordConfirm:_passwordConfirmTextField.text currentPassword:nil withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
}


@end
