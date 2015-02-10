//
//  MLAfterSalesLogisticViewController.m
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAfterSalesLogisticViewController.h"
#import "Header.h"
#import "MLSellerInfo.h"

@interface MLAfterSalesLogisticViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UILabel *sellerAddressLabel;
@property (readwrite) MLSellerInfo *sellerInfo;
@property (readwrite) UITextField *buyerNameTextField;
@property (readwrite) UITextField *buyerPhoneTextField;
@property (readwrite) UITextField *logisticCompaynTextField;
@property (readwrite) UITextField *logisticNOTextField;
@property (readwrite) UITextField *remarkTextField;

@end

@implementation MLAfterSalesLogisticViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"填写售后物流";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
	CGRect rect = CGRectZero;
	rect = self.view.bounds;
	rect.size.height -= 50;
	
	_scrollView = [[UIScrollView alloc] initWithFrame:rect];
	_scrollView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:_scrollView];
	
	rect.origin.x = edgeInsets.left;
	rect.origin.y = edgeInsets.top;
	rect.size.width = self.view.bounds.size.width - edgeInsets.left - edgeInsets.right;
	rect.size.height = 30;
	UILabel *sellerLabel = [[UILabel alloc] initWithFrame:rect];
	sellerLabel.font = [UIFont systemFontOfSize:13];
	sellerLabel.textColor = [UIColor fontGrayColor];
	sellerLabel.text = @"商家收货地址";
	[_scrollView addSubview:sellerLabel];
	
	rect.origin.y = CGRectGetMaxY(sellerLabel.frame);
	rect.size.height = 0.5;
	UIView *line = [[UIView alloc] initWithFrame:rect];
	line.backgroundColor = [UIColor backgroundColor];
	[_scrollView addSubview:line];
	
	rect.origin.y = CGRectGetMaxY(line.frame);
	rect.size.height = 40;
	_sellerAddressLabel = [[UILabel alloc] initWithFrame:rect];
	_sellerAddressLabel.font = [UIFont systemFontOfSize:15];
	_sellerAddressLabel.textColor = [UIColor fontGrayColor];
	_sellerAddressLabel.numberOfLines = 0;
	[_scrollView addSubview:_sellerAddressLabel];

	NSString *string = nil;
	NSMutableAttributedString *attributedString = nil;
	NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor themeColor]};
	NSRange range = NSMakeRange(0, 1);
	rect.origin.y = CGRectGetMaxY(_sellerAddressLabel.frame);
	rect.size.height = 30;
	UILabel *buyerNameLabel = [[UILabel alloc] initWithFrame:rect];
	buyerNameLabel.font = [UIFont systemFontOfSize:13];
	buyerNameLabel.textColor = [UIColor fontGrayColor];
	string = @"*买家姓名";
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:range];
	buyerNameLabel.attributedText = attributedString;
	[_scrollView addSubview:buyerNameLabel];
	
	rect.origin.y = CGRectGetMaxY(buyerNameLabel.frame);
	_buyerNameTextField = [[UITextField alloc] initWithFrame:rect];
	_buyerNameTextField.backgroundColor = [UIColor backgroundColor];
	_buyerNameTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	_buyerNameTextField.layer.borderWidth = 0.5;
	_buyerNameTextField.layer.cornerRadius = 4;
	[_scrollView addSubview:_buyerNameTextField];
	
	rect.origin.y = CGRectGetMaxY(_buyerNameTextField.frame);
	UILabel *buyerPhoneLabel = [[UILabel alloc] initWithFrame:rect];
	[buyerPhoneLabel sameStyleWith:buyerNameLabel];
	string = @"*发货人手机号";
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:range];
	buyerPhoneLabel.attributedText = attributedString;
	[_scrollView addSubview:buyerPhoneLabel];
	
	rect.origin.y = CGRectGetMaxY(buyerPhoneLabel.frame);
	_buyerPhoneTextField = [[UITextField alloc] initWithFrame:rect];
	[_buyerPhoneTextField sameStyleWith:_buyerNameTextField];
	[_scrollView addSubview:_buyerPhoneTextField];
	
	rect.origin.y = CGRectGetMaxY(_buyerPhoneTextField.frame);
	UILabel *logisticCompanyLabel = [[UILabel alloc] initWithFrame:rect];
	[logisticCompanyLabel sameStyleWith:buyerNameLabel];
	NSString *string2 = @"*物流公司";
	NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
	[attributedString2 addAttributes:attributes range:range];
	logisticCompanyLabel.attributedText = attributedString2;
	[_scrollView addSubview:logisticCompanyLabel];
	
	rect.origin.y = CGRectGetMaxY(logisticCompanyLabel.frame);
	_logisticCompaynTextField = [[UITextField alloc] initWithFrame:rect];
	[_logisticCompaynTextField sameStyleWith:_buyerPhoneTextField];
	[_scrollView addSubview:_logisticCompaynTextField];
	
	rect.origin.y = CGRectGetMaxY(_logisticCompaynTextField.frame);
	UILabel *logisticNOLabel = [[UILabel alloc] initWithFrame:rect];
	[logisticNOLabel sameStyleWith:logisticCompanyLabel];
	string = @"*运单号码";
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:range];
	logisticNOLabel.attributedText = attributedString;
	[_scrollView addSubview:logisticNOLabel];
	
	rect.origin.y = CGRectGetMaxY(logisticNOLabel.frame);
	_logisticNOTextField = [[UITextField alloc] initWithFrame:rect];
	[_logisticNOTextField sameStyleWith:_logisticCompaynTextField];
	[_scrollView addSubview:_logisticNOTextField];
	
	rect.origin.y = CGRectGetMaxY(_logisticNOTextField.frame);
	UILabel *remarkLabel = [[UILabel alloc] initWithFrame:rect];
	[remarkLabel sameStyleWith:logisticNOLabel];
	remarkLabel.text = @"备注";
	[_scrollView addSubview:remarkLabel];
	
	rect.origin.y = CGRectGetMaxY(remarkLabel.frame);
	_remarkTextField = [[UITextField alloc] initWithFrame:rect];
	[_remarkTextField sameStyleWith:_logisticNOTextField];
	[_scrollView addSubview:_remarkTextField];
	
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, CGRectGetMaxY(_remarkTextField.frame) + 20);
	
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 50;
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height - rect.size.height;
	UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	submitButton.frame = rect;
	submitButton.backgroundColor = [UIColor themeColor];
	[submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
	[submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	submitButton.showsTouchWhenHighlighted = YES;
	[submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:submitButton];
	
//	[self displayHUD:@"加载中..."];
//	[[MLAPIClient shared] fetchBussinessInfoForAfterSales:_afterSalesGoods withBlock:^(NSDictionary *attributes, MLResponse *response) {
//		[self displayResponseMessage:response];
//		if (response.success) {
//			_sellerInfo = [[MLSellerInfo alloc] initWithAttributes:attributes];
//			_sellerAddressLabel.text = _sellerInfo.address;
//		}
//	}];
}

- (void)submit {
	if (!_buyerNameTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写买家姓名"];
		return;
	}
	
	if (!_buyerPhoneTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写发货人手机号"];
		return;
	}
	
	if (!_logisticCompaynTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写物流公司"];
		return;
	}
	
	if (!_logisticNOTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写运单号码"];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] afterSalesSaveLogistic:_afterSalesGoods buyerName:_buyerNameTextField.text buyerPhone:_buyerPhoneTextField.text logisticCompany:_logisticCompaynTextField.text logisitcNO:_logisticNOTextField.text remark:_remarkTextField.text withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];

}


@end
