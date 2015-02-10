//
//  MLStoreCommentViewController.m
//  MoLi
//
//  Created by zhangbin on 12/20/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreCommentViewController.h"
#import "Header.h"
#import "ZBFiveStarsRateView.h"
#import "MLTextField.h"

@interface MLStoreCommentViewController ()

@property (readwrite) MLTextField *commentTextField;
@property (readwrite) ZBFiveStarsRateView *fiveStarsRateView;
@property (readwrite) UIButton *submitButton;
@property (readwrite) UIImageView *imageView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *describeLabel;

@end

@implementation MLStoreCommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"实体店评价", nil);
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
	
	CGFloat heightForSubmitButton = 50;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
	CGRect rect = CGRectZero;
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height - heightForSubmitButton;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = heightForSubmitButton;
	
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = rect;
	[_submitButton setBackgroundColor:[UIColor themeColor]];
	[_submitButton setTitle:@"确认评价" forState:UIControlStateNormal];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
	
	rect.origin.x = 0;
	rect.origin.y = 64 + 10;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 92;
	UIView *storeView = [[UIView alloc] initWithFrame:rect];
	storeView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:storeView];

	rect.origin.x = edgeInsets.left;
	rect.origin.y = edgeInsets.top;
	rect.size.width = 62;
	rect.size.height = rect.size.width;
	_imageView = [[UIImageView alloc] initWithFrame:rect];
	_imageView.backgroundColor = [UIColor redColor];
	[_imageView setImageWithURL:[NSURL URLWithString:_store.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
	[storeView addSubview:_imageView];

	rect.origin.x = CGRectGetMaxX(_imageView.frame) + 10;
	rect.size.width = self.view.bounds.size.width - rect.origin.x - edgeInsets.right;
	rect.size.height = 30;
	_nameLabel = [[UILabel alloc] initWithFrame:rect];
	_nameLabel.text = _store.name;
//	_nameLabel.backgroundColor = [UIColor blackColor];
	_nameLabel.textColor = [UIColor blackColor];
	[storeView addSubview:_nameLabel];
	
	rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
	rect.size.height = 30;
	_describeLabel = [[UILabel alloc] initWithFrame:rect];
	_describeLabel.numberOfLines = 0;
	_describeLabel.text = _store.describe;
	_describeLabel.textColor = [UIColor fontGrayColor];
//	_describeLabel.backgroundColor = [UIColor redColor];
	_describeLabel.font = [UIFont systemFontOfSize:13];
	[storeView addSubview:_describeLabel];

	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(storeView.frame) + 10;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 110;
	UIView *commentView = [[UIView alloc] initWithFrame:rect];
	commentView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:commentView];
	
	CGRect frame = CGRectZero;
	frame.origin.x = edgeInsets.left;
	frame.origin.y = edgeInsets.top;
	frame.size.width = self.view.frame.size.width - edgeInsets.left - edgeInsets.right;
	frame.size.height = 66;
	_commentTextField = [[MLTextField alloc] initWithFrame:frame];
	_commentTextField.layer.cornerRadius = 2;
	_commentTextField.layer.borderWidth = 0.5;
	_commentTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	_commentTextField.placeholder = @"嗨，来两句吧！";
	[commentView addSubview:_commentTextField];
	
	frame.origin.y = CGRectGetMaxY(_commentTextField.frame);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = NSLocalizedString(@"给店铺评分", nil);
	label.textColor = [UIColor lightGrayColor];
	[label sizeToFit];
	[commentView addSubview:label];
	
	frame.origin.x = CGRectGetMaxX(label.frame) + edgeInsets.left;
	frame.size = [ZBFiveStarsRateView size];
	_fiveStarsRateView = [[ZBFiveStarsRateView alloc] initWithFrame:frame];
	_fiveStarsRateView.star = [UIImage rateStar];
	_fiveStarsRateView.starHighlighted = [UIImage rateStarHighlighted];
	_fiveStarsRateView.rateEnable = YES;
	[commentView addSubview:_fiveStarsRateView];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
	[self.view addGestureRecognizer:tap];
}

- (void)submit {
	if (!_commentTextField.text.length) {
		[self displayHUDTitle:nil message:NSLocalizedString(@"评论内容不能为空", nil)];
		return;
	}
	
	if (![[MLAPIClient shared] sessionValid]) {
		[self displayHUDTitle:nil message:NSLocalizedString(@"请登录后进行评论", nil)];
		return;
	}
	
	[self displayHUD:NSLocalizedString(@"提交评论中...", nil)];
	[[MLAPIClient shared] submitCommentOfStore:_store.ID star:_fiveStarsRateView.rate content:_commentTextField.text withBlock:^(NSError *error) {
		[self hideHUD:YES];
		if (!error) {
			[self displayHUDTitle:nil message:NSLocalizedString(@"评论成功", nil)];
			[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_COMMENTS object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_DETAILS object:nil];
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

@end
