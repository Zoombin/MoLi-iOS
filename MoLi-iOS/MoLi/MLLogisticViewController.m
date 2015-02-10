//
//  MLLogisticViewController.m
//  MoLi
//
//  Created by zhangbin on 1/21/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLLogisticViewController.h"
#import "Header.h"

@interface MLLogisticViewController ()

@property (readwrite) UIWebView *webView;

@end

@implementation MLLogisticViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	CGRect rect = CGRectZero;
	rect.origin.x = 15;
	rect.origin.y = 80;
	rect.size.width = 50;
	rect.size.height = rect.size.width;
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
	imageView.layer.borderWidth = 0.5;
	imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //TO DO: 此处缺placeholder
	[imageView setImageWithURL:[NSURL URLWithString:_logistic.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
	[self.view addSubview:imageView];
	
	rect.origin.x = CGRectGetMaxX(imageView.frame) + 5;
	rect.size.width = self.view.bounds.size.width - rect.origin.x;
	rect.size.height = 25;
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:rect];
	nameLabel.text = _logistic.name;
	nameLabel.font = [UIFont systemFontOfSize:13];
	nameLabel.textColor = [UIColor fontGrayColor];
	[self.view addSubview:nameLabel];
	
	rect.origin.y = CGRectGetMaxY(nameLabel.frame);
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = [NSString stringWithFormat:@"运单编号:%@", _logistic.shippingNO];
	label.textColor = [UIColor fontGrayColor];
	label.font = [UIFont systemFontOfSize:13];
	[self.view addSubview:label];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(label.frame) + 10;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = self.view.bounds.size.height - rect.origin.y;
	_webView = [[UIWebView alloc] initWithFrame:rect];
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_logistic.linkURLString]]];
	[self.view addSubview:_webView];
}

@end
