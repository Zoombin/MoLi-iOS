//
//  MLIdentifyPasswordViewController.m
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLIdentifyPasswordViewController.h"
#import "Header.h"
#import "MLWebViewController.h"
#import "MLUser.h"
#import "MLTextField.h"
#import "MLTicket.h"

@interface MLIdentifyPasswordViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLTextField *passwordTextField;
@property (readwrite) MLTextField *passwordConfirmTextField;
@property (readwrite) UIButton *submitButton;
@property (readwrite) UIButton *checkBoxButton;
@property (readwrite) UILabel *protocolLabel;

@end

@implementation MLIdentifyPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"手机注册";
	[self setLeftBarButtonItemAsBackArrowButton];
	if (_verifyCode.type == MLVerifyCodeTypeForgotPassword) {
		self.title = @"找回密码";
	} else if (_verifyCode.type == MLVerifyCodeTypeForgotWalletPassword) {
		self.title = @"找回交易密码";
	}
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:_scrollView];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
	CGRect rect = CGRectMake(ML_COMMON_EDGE_LEFT, edgeInsets.top, self.view.frame.size.width, 30);
	
	NSString *phoneNumber = [NSString stringWithFormat:@"%@****%@", [_verifyCode.mobile substringToIndex:3], [_verifyCode.mobile substringFromIndex:7]];
	NSString *string = [NSString stringWithFormat:@"%@:%@", @"您本次要注册的手机号是", phoneNumber];
	if (_verifyCode.type == MLVerifyCodeTypeForgotPassword) {
		string = [NSString stringWithFormat:@"%@:%@", @"你要找回密码的手机号是", phoneNumber];
	} else if (_verifyCode.type == MLVerifyCodeTypeForgotWalletPassword) {
		string = [NSString stringWithFormat:@"%@:%@", @"你要找回交易密码的手机号是", phoneNumber];
	}
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	NSRange range = [string rangeOfString:@":"];
	if (range.location != NSNotFound) {
		[attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor themeColor], NSFontAttributeName : [UIFont systemFontOfSize:17]} range:NSMakeRange(range.location + 1, string.length - range.location - 1)];
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	[_scrollView addSubview:label];
	label.font = [UIFont systemFontOfSize:12];
	label.textColor = [UIColor fontGrayColor];
	label.attributedText = attributedString;
	[_scrollView addSubview:label];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(label.frame);
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 46;
	_passwordTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordTextField.secureTextEntry = YES;
	_passwordTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
	[_scrollView addSubview:_passwordTextField];
	
	rect.origin.y = CGRectGetMaxY(_passwordTextField.frame);
	rect.size.height = 0.5;
	UIView *line = [[UIView alloc] initWithFrame:rect];
	line.backgroundColor = [UIColor borderGrayColor];
	[_scrollView addSubview:line];
	
	rect.origin.y = CGRectGetMaxY(line.frame);
	rect.size.height = _passwordTextField.frame.size.height;
	_passwordConfirmTextField = [[MLTextField alloc] initWithFrame:rect];
	_passwordConfirmTextField.secureTextEntry = YES;
	_passwordConfirmTextField.placeholder = NSLocalizedString(@"请再次输入密码", nil);
	[_scrollView addSubview:_passwordConfirmTextField];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_passwordConfirmTextField.frame) + edgeInsets.bottom;
	rect.size.width = self.view.frame.size.width;
	rect.size.height = _passwordTextField.frame.size.height;
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = rect;
	[_submitButton setTitle:@"提交" forState:UIControlStateNormal];
	if (_verifyCode.type == MLVerifyCodeTypeSignup) {
		[_submitButton setTitle:@"注册" forState:UIControlStateNormal];
	}
	[_submitButton setBackgroundImage:[UIImage imageFromColor:[UIColor themeColor]] forState:UIControlStateNormal];
	[_submitButton setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
	[_submitButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_submitButton];
	
	if (_verifyCode.type == MLVerifyCodeTypeSignup) {
		UIImage *image = [UIImage imageNamed:@"FrameUnselected"];
		UIImage *imageSelected = [UIImage imageNamed:@"FrameSelected"];
		rect.origin.x = self.view.bounds.size.width / 2 - 100;
		rect.origin.y = CGRectGetMaxY(_submitButton.frame) + edgeInsets.bottom - 10;
		rect.size.width = 20;
		rect.size.height = 20;
		_checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_checkBoxButton.frame = rect;
		[_checkBoxButton setBackgroundImage:image forState:UIControlStateNormal];
		[_checkBoxButton setBackgroundImage:imageSelected forState:UIControlStateSelected];
		_checkBoxButton.selected = YES;
		[_checkBoxButton addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
		//[_scrollView addSubview:_checkBoxButton];
		
		rect.origin.x = CGRectGetMaxX(_checkBoxButton.frame) + 10;
		rect.size.width = self.view.frame.size.width - rect.origin.x;
		_protocolLabel = [[UILabel alloc] initWithFrame:rect];
		_protocolLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"同意", nil), NSLocalizedString(@"《魔力用户注册协议》", nil)];
		_protocolLabel.textColor = [UIColor fontGrayColor];
		_protocolLabel.font = [UIFont systemFontOfSize:15];
		_protocolLabel.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocol)];
		[_protocolLabel addGestureRecognizer:tapGestureRecognizer];
		//[_scrollView addSubview:_protocolLabel];
	}
}

- (void)signup {
	if (!_passwordTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入密码"];
		return;
	}
	
	if (!_passwordConfirmTextField.text.length) {
		[self displayHUDTitle:nil message:@"请输入确认密码"];
		return;
	}
	
	if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
		[self displayHUDTitle:nil message:@"两次输入密码不同"];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] identifyWithVerifyCode:_verifyCode password:_passwordTextField.text passwordConfirm:_passwordConfirmTextField.text withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			if (_verifyCode.type == MLVerifyCodeTypeSignup) {
				MLUser *me = [[MLUser alloc] initWithAttributes:attributes];
				[me archive];
				
				MLTicket *ticket = [MLTicket unarchive];
				[ticket setDate:[NSDate date]];
				ticket.sessionID = me.sessionID;
				[ticket archive];
			}
			[self.navigationController dismissViewControllerAnimated:YES completion:nil];
		}
	}];
}

- (void)agreeProtocol:(UIButton *)sender {
	sender.selected = !sender.selected;
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
			[self displayHUDTitle:nil message:[error MLErrorDesc]];
		}
	}];
}

@end
