//
//  MLVerifyCodeViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLVerifyCodeViewController.h"
#import "Header.h"
#import "MLWebViewController.h"
#import "MLIdentifyPasswordViewController.h"
#import "MLTextField.h"

@interface MLVerifyCodeViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLTextField *accountTextField;
@property (readwrite) MLTextField *codeTextField;
@property (readwrite) UIButton *getCodeButton;
@property (readwrite) UIButton *nextButton;
@property (readwrite) UIButton *checkBoxButton;
@property (readwrite) UILabel *protocolLabel;

@end

@implementation MLVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"手机注册", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	if (_type == MLVerifyCodeTypeForgotPassword) {
		self.title = NSLocalizedString(@"找回密码", nil);
	} else if (_type == MLVerifyCodeTypeForgotWalletPassword) {
		self.title = NSLocalizedString(@"找回交易密码", nil);
	}

	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:_scrollView];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
	CGRect rect = CGRectMake(0, edgeInsets.top, self.view.frame.size.width, 46);
	_accountTextField = [[MLTextField alloc] initWithFrame:rect];
	_accountTextField.placeholder = NSLocalizedString(@"请输入您的手机号码", nil);
	NSString *userAccount = [[MLAPIClient shared] userAccount];
	if (userAccount.length) {
		_accountTextField.text = userAccount;
	}
	[_scrollView addSubview:_accountTextField];
	
	rect.origin.y = CGRectGetMaxY(_accountTextField.frame);
	rect.size.height = 0.5;
	rect.size.width = self.view.frame.size.width;
	UIView *line = [[UIView alloc] initWithFrame:rect];
	line.backgroundColor = [UIColor borderGrayColor];
	[_scrollView addSubview:line];
	
	rect.origin.y = CGRectGetMaxY(line.frame);
	rect.size.height = _accountTextField.frame.size.height;
	_codeTextField = [[MLTextField alloc] initWithFrame:rect];
	_codeTextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
	[_scrollView addSubview:_codeTextField];
	
	rect.origin.x = (CGRectGetMaxX(_codeTextField.frame) / 2) + edgeInsets.left;
	rect.origin.y = CGRectGetMinY(_codeTextField.frame) + 10;
	rect.size.width = 130;
	rect.size.height = 30;
	_getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_getCodeButton.frame = rect;
	_getCodeButton.backgroundColor = [UIColor themeColor];
	[_getCodeButton setTitle:NSLocalizedString(@"点击获取手机验证码", nil) forState:UIControlStateNormal];
	_getCodeButton.layer.cornerRadius = 6;
	[_getCodeButton addTarget:self action:@selector(fetchCode) forControlEvents:UIControlEventTouchUpInside];
	_getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
	[_scrollView addSubview:_getCodeButton];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_codeTextField.frame) + edgeInsets.bottom;
	rect.size.width = self.view.frame.size.width;
	rect.size.height = _accountTextField.frame.size.height;
	_nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_nextButton.frame = rect;
	[_nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
	[_nextButton setBackgroundImage:[UIImage imageFromColor:[UIColor themeColor]] forState:UIControlStateNormal];
	[_nextButton setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
	[_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_nextButton];
	
	UIImage *image = [UIImage imageNamed:@"FrameUnselected"];
	UIImage *imageSelected = [UIImage imageNamed:@"FrameSelected"];
	rect.origin.x = self.view.bounds.size.width / 2 - 100;
	rect.origin.y = CGRectGetMaxY(_nextButton.frame) + edgeInsets.bottom - 10;
	rect.size.width = 20;
	rect.size.height = 20;
	_checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_checkBoxButton.frame = rect;
	[_checkBoxButton setBackgroundImage:image forState:UIControlStateNormal];
	[_checkBoxButton setBackgroundImage:imageSelected forState:UIControlStateSelected];
	_checkBoxButton.selected = YES;
	[_checkBoxButton addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_checkBoxButton];
	
	rect.origin.x = CGRectGetMaxX(_checkBoxButton.frame) + 10;
	rect.size.width = self.view.frame.size.width;
	_protocolLabel = [[UILabel alloc] initWithFrame:rect];
	_protocolLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"同意", nil), NSLocalizedString(@"《魔力用户注册协议》", nil)];
	_protocolLabel.textColor = [UIColor fontGrayColor];
	_protocolLabel.font = [UIFont systemFontOfSize:12];
	_protocolLabel.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocol)];
	[_protocolLabel addGestureRecognizer:tapGestureRecognizer];
	if (_type == MLVerifyCodeTypeSignup) {
		[_scrollView addSubview:_protocolLabel];
	}
	
	if (_type == MLVerifyCodeTypeForgotWalletPassword) {
		_checkBoxButton.hidden = YES;
		_protocolLabel.hidden = YES;
	}
	
	[self updateGetCodeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchCode {
	if (_accountTextField.text.length < 11) {
		[self displayHUDTitle:nil message:@"请填写手机号码"];
		return;
	}
	
	MLVerifyCode *verifyCode = [[MLVerifyCode alloc] init];
	verifyCode.type = _type;
	verifyCode.mobile = _accountTextField.text;
	[self displayHUD:@"请求验证码..."];
	[[MLAPIClient shared] fetchVervifyCode:verifyCode withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[MLVerifyCode fetchCodeSuccess];
			[self updateGetCodeButton];
		}
	}];
}

- (void)updateGetCodeButton {
	NSInteger countdown = [MLVerifyCode countdown];
	if (countdown > 0) {
		_getCodeButton.enabled = NO;
		_getCodeButton.backgroundColor = [UIColor grayColor];
		[_getCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取", @(countdown)] forState:UIControlStateDisabled];
		[self performSelector:@selector(updateGetCodeButton) withObject:nil afterDelay:0.5];
	} else {
		_getCodeButton.enabled = YES;
		_getCodeButton.backgroundColor = [UIColor themeColor];
	}
	
	if (_checkBoxButton.selected) {
		_nextButton.enabled = YES;
	} else {
		_nextButton.enabled = NO;
	}
}

- (void)agreeProtocol:(UIButton *)sender {
	sender.selected = !sender.selected;
	if (!sender.selected) {
		_nextButton.enabled = NO;
	}
}

- (void)next {
	if (!_codeTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写验证码"];
		return;
	}
	
	if (!_accountTextField.text.length) {
		[self displayHUDTitle:nil message:@"手机号码不能为空"];
		return;
	}

	MLVerifyCode *verifyCode = [[MLVerifyCode alloc] init];
	verifyCode.type = _type;
	verifyCode.mobile = _accountTextField.text;
	verifyCode.code = _codeTextField.text;
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] checkVervifyCode:verifyCode withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLIdentifyPasswordViewController *identifyPasswordViewController = [[MLIdentifyPasswordViewController alloc] initWithNibName:nil bundle:nil];
			identifyPasswordViewController.verifyCode = verifyCode;
			[self.navigationController pushViewController:identifyPasswordViewController animated:YES];
		}
	}];
}

- (void)protocol {
	[[MLAPIClient shared] fetchSignupTermsWithBlock:^(NSString *URLString, NSString *message, NSError *error) {
		if (!error) {
			MLWebViewController *webViewController = [[MLWebViewController alloc] initWithNibName:nil bundle:nil];
			webViewController.title = NSLocalizedString(@"《魔力用户注册协议》", nil);
			webViewController.URLString = URLString;
			webViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:webViewController animated:YES];
		} else {
			[self displayHUDTitle:nil message:error.localizedDescription];
		}
	}];
}

@end
