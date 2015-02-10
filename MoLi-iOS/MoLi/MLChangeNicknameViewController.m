//
//  MLChangeNicknameViewController.m
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLChangeNicknameViewController.h"
#import "Header.h"
#import "MLUser.h"
#import "MLTextField.h"

@interface MLChangeNicknameViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLTextField *nicknameTextField;

@end

@implementation MLChangeNicknameViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"昵称修改";
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	
	CGRect rect = CGRectMake(0, 20, self.view.bounds.size.width, 46);
	_nicknameTextField = [[MLTextField alloc] initWithFrame:rect];
	_nicknameTextField.placeholder = @"昵称";
	MLUser *me = [MLUser unarchive];
	_nicknameTextField.text = me.nickname;
	[_scrollView addSubview:_nicknameTextField];
	
	rect.origin.y = CGRectGetMaxY(_nicknameTextField.frame) + 20;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
	[button setTitle:@"确认修改" forState:UIControlStateNormal];
	button.backgroundColor = [UIColor themeColor];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:button];
}

- (void)save {
	if (!_nicknameTextField.text.length) {
		[self displayHUDTitle:nil message:@"昵称不能为空"];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	MLUser *user = [[MLUser alloc] init];
	user.nickname = _nicknameTextField.text;
	[[MLAPIClient shared] updateUserInfo:user withBlock:^(NSString *message, NSError *error) {
		if (!error) {
			if (message.length) {
				[self displayHUDTitle:nil message:message];
			} else {
				[self hideHUD:YES];
			}
			MLUser *me = [MLUser unarchive];
			if (me) {
				me.nickname = user.nickname;
				[me archive];
			}
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

@end
