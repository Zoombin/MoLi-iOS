//
//  MLDepositViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLDepositViewController.h"
#import "Header.h"
#import "MLPaymentViewController.h"
#import "MLVIPFee.h"
#import "MLWebViewController.h"

static NSString * const termName = @"《魔力会员服务条款》";

@interface MLDepositViewController () <UIActionSheetDelegate>

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UIButton *yearButton;
@property (readwrite) UIButton *tryButton;
@property (readwrite) UIButton *durationButton;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *tryLabel;
@property (readwrite) UIButton *checkBoxButton;
@property (readwrite) UILabel *protocolLabel;
@property (readwrite) UIButton *submitButton;
@property (readwrite) NSArray *fees;
@property (readwrite) MLVIPFee *yearFee;
@property (readwrite) MLVIPFee *tryFee;
@property (readwrite) MLVIPFee *selectedFee;
@property (readwrite) NSString *displayDuration;
@property (readwrite) NSString *termLink;

@end

@implementation MLDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"会员充值", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	
	CGRect rect = self.view.bounds;
	
	_scrollView = [[UIScrollView alloc] initWithFrame:rect];
	_scrollView.hidden = YES;
	[self.view addSubview:_scrollView];
	
	rect.origin.y = 20;
	rect.size.height = 135;
	CGFloat heightOfCell = (rect.size.height - 1) / 3;
	UIView *bannerView = [[UIView alloc] initWithFrame:rect];
	bannerView.backgroundColor = [UIColor whiteColor];
	[_scrollView addSubview:bannerView];
	
	rect.origin.x = ML_COMMON_EDGE_LEFT;
	rect.origin.y = 0;
	rect.size.width = 60;
	rect.size.height = heightOfCell;
	UILabel *label1 = [[UILabel alloc] initWithFrame:rect];
	label1.font = [UIFont systemFontOfSize:15];
	label1.textColor = [UIColor fontGrayColor];
	label1.text = @"付费模式";
	[bannerView addSubview:label1];
	
	CGFloat widthOfButton = (self.view.bounds.size.width - CGRectGetMaxX(label1.frame) - 3 * ML_COMMON_EDGE_LEFT) / 2;
	CGFloat heightOfButton = 34;
	rect.origin.x = CGRectGetMaxX(label1.frame) + ML_COMMON_EDGE_LEFT;
	rect.origin.y = (heightOfCell - heightOfButton) / 2;
	rect.size.width = widthOfButton;
	rect.size.height = heightOfButton;
	_yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_yearButton.frame = rect;
	_yearButton.layer.cornerRadius = 4;
	_yearButton.layer.borderColor = [[UIColor borderGrayColor] CGColor];
	_yearButton.layer.borderWidth = 0.5;
	[_yearButton setTitle:@"按年付费" forState:UIControlStateNormal];
	[_yearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[_yearButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
	_yearButton.titleLabel.font = [UIFont systemFontOfSize:13];
	[_yearButton addTarget:self action:@selector(selectFee:) forControlEvents:UIControlEventTouchUpInside];
	_yearButton.hidden = YES;
	[bannerView addSubview:_yearButton];
	
	rect.origin.x = CGRectGetMaxX(_yearButton.frame) + ML_COMMON_EDGE_LEFT;
	_tryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_tryButton.frame = rect;
	[_tryButton sameStyleWith:_yearButton];
	[_tryButton setTitle:@"试用一月" forState:UIControlStateNormal];
	[_tryButton addTarget:self action:@selector(selectFee:) forControlEvents:UIControlEventTouchUpInside];
	[_tryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[_tryButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
	_tryButton.titleLabel.font = [UIFont systemFontOfSize:13];
	_tryButton.hidden = YES;
	[bannerView addSubview:_tryButton];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(label1.frame);
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 0.5;
	UIView *line = [UIView borderLineWithFrame:rect];
	[bannerView addSubview:line];
	
	rect.origin.x = CGRectGetMinX(label1.frame);
	rect.origin.y = CGRectGetMaxY(line.frame);
	rect.size.width = CGRectGetWidth(label1.frame);
	rect.size.height = heightOfCell;
	UILabel *label2 = [[UILabel alloc] initWithFrame:rect];
	[label2 sameStyleWith:label1];
	label2.text = @"开通时长";
	[bannerView addSubview:label2];
	
	rect.origin.x = CGRectGetMaxX(label2.frame) + ML_COMMON_EDGE_LEFT;
	rect.origin.y += (heightOfCell - heightOfButton) / 2;
	rect.size.width = self.view.bounds.size.width - rect.origin.x - ML_COMMON_EDGE_LEFT;
	rect.size.height = heightOfButton;
	_durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_durationButton.frame = rect;
	_durationButton.layer.cornerRadius = 4;
	_durationButton.layer.borderWidth = 0.5;
	_durationButton.layer.borderColor = [[UIColor borderGrayColor] CGColor];
	_durationButton.titleLabel.font = [UIFont systemFontOfSize:13];
	[_durationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_durationButton addTarget:self action:@selector(selectDuration) forControlEvents:UIControlEventTouchUpInside];
	[bannerView addSubview:_durationButton];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(label2.frame);
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 0.5;
	UIView *line2 = [UIView borderLineWithFrame:rect];
	[bannerView addSubview:line2];
	
	rect.origin.x = CGRectGetMinX(label1.frame);
	rect.origin.y = CGRectGetMaxY(line2.frame);
	rect.size.width = CGRectGetWidth(label1.frame);
	rect.size.height = heightOfCell;
	UILabel *label3 = [[UILabel alloc] initWithFrame:rect];
	[label3 sameStyleWith:label1];
	label3.text = @"应付金额";
	[bannerView addSubview:label3];

	rect.origin.x = CGRectGetMaxX(label3.frame) + ML_COMMON_EDGE_LEFT;
	rect.size.width = 60;
	_priceLabel = [[UILabel alloc] initWithFrame:rect];
	_priceLabel.font = [UIFont systemFontOfSize:18];
	_priceLabel.textColor = [UIColor themeColor];
	[bannerView addSubview:_priceLabel];
	
	rect.origin.x = CGRectGetMaxX(_priceLabel.frame);
	rect.size.width = self.view.bounds.size.width - rect.origin.x;
	_tryLabel = [[UILabel alloc] initWithFrame:rect];
	_tryLabel.font = [UIFont systemFontOfSize:11];
	_tryLabel.textColor = [UIColor fontGrayColor];
	_tryLabel.text = @"(每个用户只能试用一次)";
	_tryLabel.hidden = YES;
	[bannerView addSubview:_tryLabel];
	
	UIImage *image = [UIImage imageNamed:@"FrameUnselected"];
	UIImage *imageSelected = [UIImage imageNamed:@"FrameSelected"];
	rect.origin.x = self.view.bounds.size.width / 2 - 120;
	rect.origin.y = CGRectGetMaxY(bannerView.frame) + 20;
	rect.size.width = 20;
	rect.size.height = 20;
	_checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_checkBoxButton.frame = rect;
	[_checkBoxButton setBackgroundImage:image forState:UIControlStateNormal];
	[_checkBoxButton setBackgroundImage:imageSelected forState:UIControlStateSelected];
	_checkBoxButton.selected = YES;
	[_checkBoxButton addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
	_checkBoxButton.hidden = YES;
	[_scrollView addSubview:_checkBoxButton];
	
	rect.origin.x = CGRectGetMaxX(_checkBoxButton.frame) + 10;
	rect.size.width = self.view.frame.size.width - rect.origin.x;
	_protocolLabel = [[UILabel alloc] initWithFrame:rect];
	_protocolLabel.text = [NSString stringWithFormat:@"%@%@", @"我已经阅读并同意", termName];
	_protocolLabel.textColor = [UIColor fontGrayColor];
	_protocolLabel.font = [UIFont systemFontOfSize:12];
	_protocolLabel.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocol)];
	[_protocolLabel addGestureRecognizer:tapGestureRecognizer];
	_protocolLabel.hidden = YES;
	[_scrollView addSubview:_protocolLabel];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_protocolLabel.frame) + 30;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 50;
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = rect;
	_submitButton.backgroundColor = [UIColor themeColor];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"确认支付" forState:UIControlStateNormal];
	_submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
	[_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	_submitButton.hidden = YES;
	[_scrollView addSubview:_submitButton];
	
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] VIPFeeWithBlock:^(NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_scrollView.hidden = NO;
			_termLink = response.data[@"termlink"];
			if (_termLink) {
				_checkBoxButton.hidden = NO;
				_protocolLabel.hidden = NO;
				_submitButton.hidden = NO;
			}
			
			_fees = [MLVIPFee multiWithAttributesArray:multiAttributes];
			_yearFee = [MLVIPFee yearFeeInFees:_fees];
			_tryFee = [MLVIPFee tryFeeInFees:_fees];
			if (_yearFee) {
				_yearButton.hidden = NO;
			}
			if (_tryFee) {
				_tryButton.hidden = NO;
			}
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)agreeProtocol:(UIButton *)button {
	button.selected = !button.selected;
}

- (void)protocol {
	MLWebViewController *webViewController = [[MLWebViewController alloc] initWithNibName:nil bundle:nil];
	webViewController.URLString = _termLink;
	webViewController.title = termName;
	[self.navigationController pushViewController:webViewController animated:YES];
}

- (void)selectDuration {
	if (_selectedFee != _yearFee) {
		return;
	}
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"一年", @"两年", @"三年", @"四年", @"五年", nil];
	[actionSheet showInView:self.view];
}

- (void)submit {
	if (!_checkBoxButton.selected) {
		[self displayHUDTitle:nil message:[NSString stringWithFormat:@"请先同意%@", termName]];
		return;
	}
	
	if (!_selectedFee) {
		[self displayHUDTitle:nil message:@"请选择付费模式"];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] preparePayVIP:_selectedFee withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];		
		if (response.success) {
			MLOrderResult *orderResult = [[MLOrderResult alloc] initWithAttributes:attributes];
			MLPaymentViewController *paymentViewController = [[MLPaymentViewController alloc] initWithNibName:nil bundle:nil];
			paymentViewController.orderResult = orderResult;
			[self.navigationController pushViewController:paymentViewController animated:YES];
			
		}
	}];
	
}

- (void)selectFee:(UIButton *)button {
	_yearButton.selected = NO;
	_tryButton.selected = NO;
	button.selected = YES;
	_yearButton.layer.borderColor = _yearButton.selected ? [[UIColor themeColor] CGColor] : [[UIColor borderGrayColor] CGColor];
	_tryButton.layer.borderColor = _tryButton.selected ? [[UIColor themeColor] CGColor] : [[UIColor borderGrayColor] CGColor];
	
	if (_yearButton.selected) {
		_selectedFee = _yearFee;
		_tryLabel.hidden = YES;
	} else if (_tryButton.selected) {
		_selectedFee = _tryFee;
		_tryLabel.hidden = NO;
	}
	[self refreshDurationAndPrice];
}

- (void)refreshDurationAndPrice {
	if (_selectedFee == _yearFee) {
		_displayDuration = @"一年";
		if (_yearFee.duration.integerValue == 2) {
			_displayDuration = @"两年";
		} else if (_yearFee.duration.integerValue == 3) {
			_displayDuration = @"三年";
		} else if (_yearFee.duration.integerValue == 4) {
			_displayDuration = @"四年";
		} else if (_yearFee.duration.integerValue == 5) {
			_displayDuration = @"五年";
		}
	} else if (_selectedFee == _tryFee) {
		_displayDuration = @"一个月";
	}
	[_durationButton setTitle:_displayDuration forState:UIControlStateNormal];
	_priceLabel.text = [NSString stringWithFormat:@"¥%@", @([_selectedFee.fee floatValue] * [_selectedFee.duration integerValue])];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	_yearFee.duration = @(buttonIndex + 1);
	[self refreshDurationAndPrice];
}

@end
