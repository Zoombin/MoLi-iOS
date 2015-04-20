//
//  MLSigninViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLSigninViewController.h"
#import "Header.h"
#import "MLVerifyCodeViewController.h"
#import "MLUser.h"
#import "MLVerifyCode.h"
#import "MLTextField.h"
#import "MLTicket.h"

@interface MLSigninViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLTextField *accountTextField;
@property (readwrite) MLTextField *passwordTextField;
@property (readwrite) UIButton *signinButton;
@property (readwrite) UILabel *signupLabel;
@property (readwrite) UILabel *forgotPasswordLabel;

@end

@implementation MLSigninViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.title = NSLocalizedString(@"登录", nil);
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:_scrollView];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 20, 10, 20);
	CGRect rect = CGRectMake(0, edgeInsets.top, self.view.frame.size.width, 46);
	_accountTextField = [[MLTextField alloc] initWithFrame:rect];
	_accountTextField.placeholder = NSLocalizedString(@"请输入您的手机号码", nil);
	[_scrollView addSubview:_accountTextField];
	
	rect.origin.y = CGRectGetMaxY(_accountTextField.frame);
	rect.size.height = 0.5;
	UIView *line = [[UIView alloc] initWithFrame:rect];
	line.backgroundColor = [UIColor borderGrayColor];
	[_scrollView addSubview:line];
	
	rect.origin.y = CGRectGetMaxY(line.frame);
	rect.size.height = _accountTextField.frame.size.height;
	_passwordTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordTextField.placeholder = NSLocalizedString(@"请输入您的密码", nil);
	_passwordTextField.secureTextEntry = YES;
	[_scrollView addSubview:_passwordTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordTextField.frame) + edgeInsets.bottom + 10;
	_signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_signinButton.frame = rect;
	[_signinButton setTitle:NSLocalizedString(@"立即登录", nil) forState:UIControlStateNormal];
	[_signinButton setBackgroundColor:[UIColor themeColor]];
	[_signinButton addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_signinButton];
	
	rect.origin.x = edgeInsets.left;
	rect.origin.y = CGRectGetMaxY(_signinButton.frame) + edgeInsets.bottom;
	rect.size.width = (self.view.frame.size.width - edgeInsets.left - edgeInsets.right) / 2;
	rect.size.height = 20;
	_signupLabel = [[UILabel alloc] initWithFrame:rect];
	_signupLabel.backgroundColor = [UIColor clearColor];
	_signupLabel.textColor = [UIColor fontGrayColor];
	_signupLabel.text = NSLocalizedString(@"快速注册", nil);
	_signupLabel.font = [UIFont systemFontOfSize:13];
	_signupLabel.userInteractionEnabled = YES;
	[_scrollView addSubview:_signupLabel];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signup)];
	[_signupLabel addGestureRecognizer:tapGestureRecognizer];
	
	rect.origin.x = CGRectGetMaxX(_signupLabel.frame);
	_forgotPasswordLabel = [[UILabel alloc] initWithFrame:rect];
	_forgotPasswordLabel.backgroundColor = [UIColor clearColor];
	_forgotPasswordLabel.textColor = [UIColor lightGrayColor];
	_forgotPasswordLabel.text = NSLocalizedString(@"忘记密码?", nil);
	_forgotPasswordLabel.font = _signupLabel.font;
	_forgotPasswordLabel.userInteractionEnabled = YES;
	_forgotPasswordLabel.textAlignment = NSTextAlignmentRight;
	[_scrollView addSubview:_forgotPasswordLabel];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword)];
	[_forgotPasswordLabel addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([[MLAPIClient shared] userAccount].length) {
		_accountTextField.text = [[MLAPIClient shared] userAccount];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds , 10 , 10 );
}

- (void)signin {
#warning hardcode signin
//	_accountTextField.text = @"18061933350";
//	_passwordTextField.text = @"123456";
//
//	_accountTextField.text = @"18662606288";
//	_passwordTextField.text = @"111111";
//	交易密码：111111
	
//	_accountTextField.text = @"18662670711";
//	_passwordTextField.text = @"111111";

//shaodong 支付密码123456
//	_accountTextField.text = @"18662430879";
//	_passwordTextField.text = @"111111";

	_accountTextField.text = @"18662430878";
	_passwordTextField.text = @"123456";
	
//	_accountTextField.text = @"18061933350";
//	_passwordTextField.text = @"123456";

//    _accountTextField.text = @"13862090556";
//    _passwordTextField.text = @"123456";

	if (!_passwordTextField.text.length) {
		[self displayHUDTitle:nil message:NSLocalizedString(@"密码不能为空", nil)];
		return;
	}
	if (!_accountTextField.text.length) {
		[self displayHUDTitle:nil message:NSLocalizedString(@"账号不能为空", nil)];
		return;
	}
	
	[self displayHUD:@"登录中..."];
	[[MLAPIClient shared] signinWithAccount:_accountTextField.text password:_passwordTextField.text withBlock:^(NSDictionary *attributes, MLResponse *response, NSError *error) {
		[self hideHUD:NO];
		[self displayResponseMessage:response];
		if (response.success) {
			MLUser *me = [[MLUser alloc] initWithAttributes:attributes];
			[me archive];
			
			MLTicket *ticket = [MLTicket unarchive];
			ticket.sessionID = me.sessionID;
			[ticket setDate:[NSDate date]];
			[ticket archive];
			
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		
		if (error) {
			[self displayHUDTitle:nil message:error.localizedDescription];
		}
	}];
}

- (void)signup {
	[self presentViewController:MLVerifyCodeTypeSignup];
}

- (void)forgotPassword {
	[self presentViewController:MLVerifyCodeTypeForgotPassword];
}

- (void)presentViewController:(MLVerifyCodeType)verifyCodeType {
	MLVerifyCodeViewController *verfiyCodeViewController = [[MLVerifyCodeViewController alloc] initWithNibName:nil bundle:nil];
	verfiyCodeViewController.type = verifyCodeType;
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:verfiyCodeViewController] animated:YES completion:nil];
}


@end
